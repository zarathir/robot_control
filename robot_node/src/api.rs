use serde::{Deserialize, Serialize};

use crate::node::{self, Twist};

#[derive(Debug, Clone, Copy, Serialize, Deserialize, Default, PartialEq)]
pub struct Vector3 {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

pub fn node_handle() {
    node::init_node();
}

pub fn publish_twist(topic: String, linear: Vector3, angular: Vector3) {
    let data = Twist { linear, angular };

    node::publish_message(topic, data);
}
