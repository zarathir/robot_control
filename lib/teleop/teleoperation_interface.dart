abstract class TeleoperationInterface {
  void init() {}

  Future<void> move(String topic, double x, double z, double speed) async {}
}
