# Robot Control App

This is a flutter project to control a turtlebot over zenoh/ROS2.
The goal is to control the turtlebot with the gyroscope of a phone or over the buttons on a desktop pc.

## TODO

- [ ] Change turtlebot controls to continious control
- [ ] Add gyroscope control
- [ ] Add rust interface similar to [Zenoh](https://github.com/eclipse-zenoh/zenoh-demos/tree/master/ROS2/zenoh-rust-teleop)
- [ ] Change API for Web and Mobile to REST API calls, because frb doesn't support web and zenoh does not compile on android
