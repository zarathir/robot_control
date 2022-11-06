use cdr::{CdrLe, Infinite};

use crate::node::{init_node, publish_message, Twist};

pub fn node_handle(url: String) -> anyhow::Result<()> {
    init_node(url);
    Ok(())
}

pub fn publish_movement(topic: String, x: f64, z: f64) {
    let twist = Twist::from_x_z(x, z);
    let data = cdr::serialize::<_, _, CdrLe>(&twist, Infinite).unwrap();
    publish_message(topic, data);
}
