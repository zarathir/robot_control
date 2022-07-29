import 'package:robot_control/ffi.dart';
import 'package:robot_control/teleop/teleoperation_interface.dart';

class TeleopZenoh implements TeleoperationInterface {
  String url;

  TeleopZenoh(this.url);

  @override
  void init() {
    api.nodeHandle(url: url);
  }

  @override
  Future<void> move(String topic, double x, double z, double speed) async {
    await api.generateTwist(topic: topic, x: x, z: z);
  }
}
