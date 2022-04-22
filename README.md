# Robot Control

This is a flutter project to control a turtlebot over zenoh. It is highly inspired by the Blogpost of the zenoh team.
The goal is to control the turtlebot with the gyroscope of a phone or over the buttons on a desktop pc.

Currently the turtlebot is controlled over grpc.

The implemented rust code is still WIP.

TODO:

- [ ] Change turtlebot controls to continious control
- [ ] Add gyroscope control
- [ ] Add rust interface similar to [Zenoh](https://github.com/atolab/zenoh-demo/tree/main/ROS2/zenoh-rust-teleop)
- [ ] Add rust tests to test the zenoh client

## flutter_rust_bridge specific stuff for future reference

To begin, ensure that you have a working installation of the following items:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Rust language](https://rustup.rs/)
- Appropriate [Rust targets](https://rust-lang.github.io/rustup/cross-compilation.html) for cross-compiling to your device
- For Android targets:
  - Install [cargo-ndk](https://github.com/bbqsrc/cargo-ndk#installing)
  - Install Android NDK 22, then put its path in one of the `gradle.properties`, e.g.:

```
echo "ANDROID_NDK=.." >> ~/.gradle/gradle.properties
```

- Web is not supported yet.

Then go ahead and run `flutter run`! When you're ready, refer to our documentation
[here](https://fzyzcjy.github.io/flutter_rust_bridge/index.html)
to learn how to write and use binding code.
