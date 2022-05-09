use cdr::{CdrLe, Infinite};
use flutter_rust_bridge::support::lazy_static;
use futures::executor;
use serde::{Deserialize, Serialize};

use std::thread;

use crate::helper::{Comms, Message, TopicMessage, ZenohSession};

lazy_static! {
    static ref COMMUNICATOR: Comms = Comms::new();
    static ref ZENOH_SESSION: ZenohSession = ZenohSession::new();
}

#[derive(Debug, Clone, Copy)]
pub struct OptionTwist {
    pub linear: Option<Vec3>,
    pub angular: Option<Vec3>,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
struct Twist {
    linear: Vec3,
    angular: Vec3,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize, Default, PartialEq)]
pub struct Vec3 {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

pub fn node_handle() {
    thread::spawn(move || loop {
        match COMMUNICATOR.receiver.lock().unwrap().recv().unwrap() {
            Message::Send(message) => {
                executor::block_on(async {
                    ZENOH_SESSION
                        .session
                        .lock()
                        .unwrap()
                        .put(message.topic, message.data)
                        .await
                        .unwrap();
                });
            }
            Message::Shutdown => {
                break;
            }
        }
    });
}

pub fn publish_message(topic: String, data: OptionTwist) {
    let data = unwrap_message(data);

    COMMUNICATOR
        .sender
        .lock()
        .unwrap()
        .send(Message::Send(TopicMessage::new(
            topic,
            cdr::serialize::<_, _, CdrLe>(&data, Infinite).unwrap(),
        )))
        .unwrap();
}

fn unwrap_message(data: OptionTwist) -> Twist {
    Twist {
        linear: data.linear.unwrap(),
        angular: data.angular.unwrap(),
    }
}

pub fn shutdown() {
    COMMUNICATOR
        .sender
        .lock()
        .unwrap()
        .send(Message::Shutdown)
        .unwrap();
}

#[cfg(test)]
mod tests {
    use std::thread;

    use super::{node_handle, publish_message, OptionTwist, Twist, Vec3};
    use futures::StreamExt;
    use rand::{thread_rng, Rng};
    use zenoh::prelude::SplitBuffer;

    fn create_test_data() -> OptionTwist {
        let mut rng = thread_rng();

        let linear = Vec3 {
            x: rng.gen_range(-5.0..10.0),
            y: 0.0,
            z: 0.0,
        };

        let angular = Vec3 {
            x: 0.0,
            y: 0.0,
            z: rng.gen_range(-5.0..10.0),
        };

        OptionTwist {
            linear: Some(linear),
            angular: Some(angular),
        }
    }

    #[async_std::test]
    async fn test_node_handle_valid() {
        let session = zenoh::open(zenoh::config::peer()).await.unwrap();

        let mut subscriber = session.subscribe("/test").await.unwrap();

        let option_twist = create_test_data();

        let twist = Twist {
            linear: option_twist.linear.unwrap(),
            angular: option_twist.angular.unwrap(),
        };

        thread::spawn(move || {
            node_handle();

            publish_message("/test".to_string(), option_twist);
        });

        let sample = subscriber.next().await.unwrap();

        let twist_reply = cdr::deserialize(&sample.value.payload.contiguous()).unwrap();

        assert_eq!(twist, twist_reply);
    }
}
