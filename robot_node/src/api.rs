use cdr::{CdrLe, Infinite};
use flutter_rust_bridge::ZeroCopyBuffer;

use crate::node::Twist;

cfg_if::cfg_if!(
    if #[cfg(not(target_os = "android"))] {
        use crate::node;
    }
);

pub fn node_handle(url: String) -> anyhow::Result<()> {
    cfg_if::cfg_if!(
        if #[cfg(not(target_os = "android"))] {
            node::init_node(url);
        } else {
            Err("Not implemented for this plaftorm.")
        }
    );
    Ok(())
}

pub fn generate_twist(topic: String, x: f64, z: f64) -> Option<ZeroCopyBuffer<Vec<u8>>> {
    let msg = Twist::from_x_z(x, z);
    let data = cdr::serialize::<_, _, CdrLe>(&msg, Infinite).unwrap();

    cfg_if::cfg_if!(
    if #[cfg(target_os = "android")] {
        Some(ZeroCopyBuffer(data))
    } else {
        node::publish_message(topic, data);
    });
    None
}
