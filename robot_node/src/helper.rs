use std::sync::{
    mpsc::{self, Receiver, Sender},
    Mutex,
};
use zenoh::prelude::ZFuture;

use zenoh::Session;

pub struct Comms {
    pub sender: Mutex<Sender<Message>>,
    pub receiver: Mutex<Receiver<Message>>,
}

impl Comms {
    pub fn new() -> Self {
        let (tx, rx) = mpsc::channel::<Message>();

        let sender = Mutex::new(tx);
        let receiver = Mutex::new(rx);

        Comms { sender, receiver }
    }
}

pub struct ZenohSession {
    pub session: Mutex<Session>,
}

impl ZenohSession {
    pub fn new() -> Self {
        let config = zenoh::config::peer();
        let session = Mutex::new(zenoh::open(config).wait().unwrap());

        ZenohSession { session }
    }
}

pub struct TopicMessage {
    pub topic: String,
    pub data: Vec<u8>,
}

impl TopicMessage {
    pub fn new(topic: String, data: Vec<u8>) -> TopicMessage {
        TopicMessage { topic, data }
    }
}

pub enum Message {
    Send(TopicMessage),
    Shutdown,
}
