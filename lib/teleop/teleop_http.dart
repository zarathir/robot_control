import 'package:http/http.dart';
import 'package:robot_control/ffi.dart';
import 'package:robot_control/teleop/teleoperation_interface.dart';

class TeleopHttp implements TeleoperationInterface {
  late Client client;
  late String url;

  TeleopHttp(this.url);

  @override
  void init() {
    client = Client();
  }

  @override
  Future<void> move(String topic, double x, double z, double speed) async {
    var msg = await api.generateTwist(topic: topic, x: x, z: z);

    await client.put(Uri.http(url, topic), body: msg);
  }
}
