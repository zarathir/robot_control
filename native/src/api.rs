use zenoh::prelude::ZFuture;

pub struct Handler {
    zenoh_session: zenoh::Session,
}

pub struct Twist {
    linear: Vector3,
    angular: Vector3,
}

struct Vector3 {
    x: f32,
    y: f32,
    z: f32,
}

impl Handler {
    pub fn new() -> Handler {
        let config = zenoh::config::default();
        let zenoh_session = zenoh::open(config).wait().unwrap();

        Handler { zenoh_session }
    }
    /*
    pub async fn put(&self, value: Twist) {
        let workspace = self
            .zenoh_session
            .put(&"/rt/cmd_vel".try_into().unwrap(), value)
            .await
            .unwrap();
    }*/
}
