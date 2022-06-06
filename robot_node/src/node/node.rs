use cdr::{CdrLe, Infinite};
use flutter_rust_bridge::support::lazy_static;
use futures::executor;
use serde::Serialize;
use std::thread;

use crate::node::helper::{Comms, Message};

lazy_static! {
    static ref COMMUNICATOR: Comms = Comms::new();
}

pub fn init_node(url: String) {
    cfg_if::cfg_if! {
        if #[cfg(target_os = "android")]{
            rest_node(url);
        } else {
            zenoh_node();
        }
    }
}

pub fn publish_message<S: Serialize>(topic: String, msg: S) {
    let data = cdr::serialize::<_, _, CdrLe>(&msg, Infinite).unwrap();

    COMMUNICATOR
        .sender
        .lock()
        .unwrap()
        .send(Message::new(topic, data))
        .unwrap();
}

#[cfg(not(target_os = "android"))]
fn zenoh_node() {
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

#[cfg(target_os = "android")]
fn rest_node(url: String) {
    use reqwest::Client;

    let client = Client::new();

    thread::spawn(move || loop {
        let msg = COMMUNICATOR.receiver.lock().unwrap().recv().unwrap();

        executor::block_on(async {
            let res = client
                .put(url + &msg.topic)
                .body(msg.data)
                .header("Content-Type", "application/octet-stream")
                .send()
                .await
                .unwrap();
        });
    });
}

#[cfg(test)]
mod tests {
    use std::thread;

    use crate::{
        api::Vector3,
        node::{init_node, msg::Twist},
    };

    use super::publish_message;
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

            publish_message("/test".to_string(), twist);
        });

        let sample = subscriber.next().await.unwrap();

        let twist_reply = cdr::deserialize(&sample.value.payload.contiguous()).unwrap();

        assert_eq!(twist, twist_reply);
    }
}
