import 'package:robot_control/teleop/teleoperation_interface.dart';

import '../robot_node/ffi.dart'
    if (dart.library.html) '../robot_node/ffi_web.dart';

class TeleopZenoh implements TeleoperationInterface {
  String url;

  TeleopZenoh(this.url);

  @override
  void init() {
    robotNode.nodeHandle(url: url);
  }

  @override
  Future<void> move(String topic, double x, double z) async {
    await robotNode.publishMovement(topic: topic, x: x, z: z);
  }
}
