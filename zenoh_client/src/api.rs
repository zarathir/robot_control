use cdr::{CdrLe, Infinite};
use flutter_rust_bridge::support::lazy_static;
use futures::executor;
use serde::{Deserialize, Serialize};

use std::thread;

use crate::helper::{Comms, Message, ZenohSession};

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

pub fn node_handle(cmd_key: String) {
    thread::spawn(move || loop {
        match COMMUNICATOR.receiver.lock().unwrap().recv().unwrap() {
            Message::Send(data) => {
                executor::block_on(async {
                    ZENOH_SESSION
                        .session
                        .lock()
                        .unwrap()
                        .put(cmd_key.clone(), data)
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

pub fn publish_message(data: OptionTwist) {
    let data = unwrap_message(data);

    COMMUNICATOR
        .sender
        .lock()
        .unwrap()
        .send(Message::Send(
            cdr::serialize::<_, _, CdrLe>(&data, Infinite).unwrap(),
        ))
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
    use futures::{executor, StreamExt};
    use rand::{thread_rng, Rng};
    use zenoh::{prelude::ZFuture, Session};

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

    fn spawn_subscriber() -> Session {
        zenoh::open(zenoh::config::peer()).wait().unwrap()
    }

    #[test]
    fn test_node_handle_valid() {
        node_handle("/test".to_string());

        let subscriber = spawn_subscriber();

        let option_twist = create_test_data();

        let twist = Twist {
            linear: option_twist.linear.unwrap(),
            angular: option_twist.angular.unwrap(),
        };

        let mut reply = Twist {
            linear: Vec3::default(),
            angular: Vec3::default(),
        };

        let mut data_received = false;

        let handle = thread::spawn(move || {
            let mut replies = subscriber.get("/test/**").wait().unwrap();

            executor::block_on(async {
                while let Some(value) = replies.next().await {
                    reply = cdr::deserialize(value.sample.value.payload.get_zslice(0).unwrap())
                        .unwrap();
                    data_received = true;
                }
            })
        });

        publish_message(option_twist);

        handle.join().unwrap();
        assert_eq!(twist, reply);
    }
}
