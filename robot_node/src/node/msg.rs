use serde::{Deserialize, Serialize};

use crate::api::Vector3;

#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct Twist {
    pub linear: Vector3,
    pub angular: Vector3,
}
