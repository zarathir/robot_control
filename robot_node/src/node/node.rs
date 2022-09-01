use flutter_rust_bridge::support::lazy_static;

use crate::node::comms::{Comms, Message};

lazy_static! {
    static ref COMMUNICATOR: Comms = Comms::new();
}

#[cfg(not(target_os = "android"))]
pub fn init_node(url: String) {
    use futures::executor;
    use std::thread;
    use zenoh::prelude::ZFuture;

    let config = zenoh::config::peer();
    let session = zenoh::open(config).wait().unwrap();

    thread::spawn(move || loop {
        let msg = COMMUNICATOR.receiver.lock().unwrap().recv().unwrap();

        executor::block_on(async {
            session.put(msg.topic, msg.data).await.unwrap();
        });
    });
}

pub fn publish_message(topic: String, data: Vec<u8>) {
    COMMUNICATOR
        .sender
        .lock()
        .unwrap()
        .send(Message::new(topic, data))
        .unwrap();
}

#[cfg(test)]
mod tests {
    use std::thread;

    use crate::node::{init_node, msg::Twist, Vector3};

    use super::publish_message;
    use cdr::{CdrLe, Infinite};
    use futures::StreamExt;
    use rand::{thread_rng, Rng};
    use zenoh::prelude::SplitBuffer;

    fn create_test_data() -> Twist {
        let mut rng = thread_rng();

        let linear = Vector3 {
            x: rng.gen_range(-5.0..10.0),
            y: 0.0,
            z: 0.0,
        };

        let angular = Vector3 {
            x: 0.0,
            y: 0.0,
            z: rng.gen_range(-5.0..10.0),
        };

        Twist { linear, angular }
    }

    #[async_std::test]
    async fn test_node_handle_valid() {
        let session = zenoh::open(zenoh::config::peer()).await.unwrap();

        let mut subscriber = session.subscribe("/test").await.unwrap();

        let twist = create_test_data();

        thread::spawn(move || {
            init_node("".to_string());

            publish_message(
                "/test".to_string(),
                cdr::serialize::<_, _, CdrLe>(&twist, Infinite).unwrap(),
            );
        });

        let sample = subscriber.next().await.unwrap();

        let twist_reply = cdr::deserialize(&sample.value.payload.contiguous()).unwrap();

        assert_eq!(twist, twist_reply);
    }
}
