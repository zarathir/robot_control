use cdr::{CdrLe, Infinite};
use futures::executor;
use serde_derive::Serialize;
use zenoh::prelude::ZFuture;

#[derive(Serialize)]
pub struct Twist {
    linear: Vector3,
    angular: Vector3,
}

#[derive(Serialize)]
pub struct Vector3 {
    x: f64,
    y: f64,
    z: f64,
}

pub fn pub_twist(cmd_key: String, linear: f64, angular: f64) {
    let config = zenoh::config::peer();
    let session = zenoh::open(config).wait().unwrap();

    let twist = Twist {
        linear: Vector3 {
            x: linear,
            y: 0.0,
            z: 0.0,
        },
        angular: Vector3 {
            x: 0.0,
            y: 0.0,
            z: angular,
        },
    };

    executor::block_on(async {
        let encoded = cdr::serialize::<_, _, CdrLe>(&twist, Infinite).unwrap();
        session.put(cmd_key, encoded).await.unwrap();
    });
}
