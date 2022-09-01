use std::sync::{
    mpsc::{self, Receiver, Sender},
    Mutex,
};

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

pub struct Message {
    pub topic: String,
    pub data: Vec<u8>,
}

impl Message {
    pub fn new(topic: String, data: Vec<u8>) -> Self {
        Message { topic, data }
    }
}
