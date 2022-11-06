use flutter_rust_bridge::support::lazy_static;
use std::thread;
use zenoh::prelude::sync::*;

use crate::node::comms::{Comms, Message};

lazy_static! {
    static ref COMMUNICATOR: Comms = Comms::new();
    static ref NODE: Node = Node::new();
}

struct Node {
    session: Session,
}

impl Node {
    pub fn new() -> Self {
        let config = zenoh::config::peer();
        let session = zenoh::open(config).res().unwrap();

        Node { session }
    }
}

pub fn init_node(url: String) {
    thread::spawn(move || loop {
        let msg = COMMUNICATOR.receiver.lock().unwrap().recv().unwrap();

        NODE.session.put(msg.topic, msg.data).res().unwrap();
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

    use crate::node::{init_node, Twist};

    use super::publish_message;
    use cdr::{CdrLe, Infinite};
    use rand::{thread_rng, Rng};
    use zenoh::prelude::r#sync::*;

    #[test]
    fn test_node_handle_valid() {
        let session = zenoh::open(zenoh::config::peer()).res().unwrap();

        let subscriber = session.declare_subscriber("test").res().unwrap();

        let mut rng = thread_rng();
        let twist = Twist::from_x_z(rng.gen_range(-5.0..10.0), rng.gen_range(-5.0..10.0));

        thread::spawn(move || {
            init_node("".to_string());

            publish_message(
                "test".to_string(),
                cdr::serialize::<_, _, CdrLe>(&twist, Infinite).unwrap(),
            );
        });

        let sample = subscriber.recv().unwrap();

        let twist_reply = cdr::deserialize(&sample.value.payload.contiguous()).unwrap();

        assert_eq!(twist, twist_reply);
    }
}
