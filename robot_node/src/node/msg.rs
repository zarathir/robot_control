use serde_derive::{Deserialize, Serialize};

#[repr(C)]
#[derive(Debug, Clone, Copy, Serialize, Deserialize, Default, PartialEq)]
pub struct Vector3 {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

impl Vector3 {
    pub fn from_x(x: f64) -> Self {
        Vector3 { x, y: 0.0, z: 0.0 }
    }

    pub fn from_z(z: f64) -> Self {
        Vector3 { x: 0.0, y: 0.0, z }
    }
}

#[repr(C)]
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq)]
pub struct Twist {
    pub linear: Vector3,
    pub angular: Vector3,
}

impl Twist {
    pub fn from_x_z(x: f64, z: f64) -> Twist {
        Twist {
            linear: Vector3::from_x(x),
            angular: Vector3::from_z(z),
        }
    }
}
