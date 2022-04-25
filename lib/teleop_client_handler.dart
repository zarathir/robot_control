import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:robot_control/ffi.dart';

class TeleopClientHandler {
  static const turtlebotMaxLinVel = 0.22;
  static const turtlebotMaxAngVel = 2.84;

  static const linearVelStepSize = 0.01;
  static const angularVelStepSize = 0.1;

  double targetLinearVel = 0;
  double targetAngularVel = 0;
  double controlLinearVel = 0;
  double controlAngularVel = 0;

  late ClientChannel channel;

  TeleopClientHandler(String cmdKey) {
    api.nodeHandle(cmdKey: cmdKey);
  }

  double _makeSimpleProfile(double output, double input, double slop) {
    if (input > output) {
      output = min(input, output + slop);
    } else if (input < output) {
      output = max(input, output - slop);
    } else {
      output = input;
    }

    return output;
  }

  double _constrain(double input, double low, double high) {
    if (input < low) {
      input = low;
    } else if (input > high) {
      input = high;
    }

    return input;
  }

  double _checkLinearLimitVelocity(double vel) {
    return _constrain(vel, -turtlebotMaxLinVel, turtlebotMaxLinVel);
  }

  double _checkAngualarLimitVelocity(double vel) {
    return _constrain(vel, -turtlebotMaxAngVel, turtlebotMaxAngVel);
  }

  Future<void> _sendCommand() async {
    controlLinearVel = _makeSimpleProfile(
        controlLinearVel, targetLinearVel, (linearVelStepSize / 2.0));

    controlAngularVel = _makeSimpleProfile(
        controlAngularVel, targetAngularVel, (angularVelStepSize / 2.0));

    var linear = Vec3(x: controlLinearVel, y: 0, z: 0);
    var angular = Vec3(x: 0, y: 0, z: controlAngularVel);

    var twist = OptionTwist(linear: linear, angular: angular);

    api.publishMessage(data: twist);
  }

  Future<void> accelerate() async {
    targetLinearVel =
        _checkLinearLimitVelocity(targetLinearVel + linearVelStepSize);

    _sendCommand();
  }

  Future<void> decelerate() async {
    targetLinearVel =
        _checkLinearLimitVelocity(targetLinearVel - linearVelStepSize);

    _sendCommand();
  }

  Future<void> leftwards() async {
    targetAngularVel =
        _checkAngualarLimitVelocity(targetAngularVel + angularVelStepSize);

    _sendCommand();
  }

  Future<void> rightwards() async {
    targetAngularVel =
        _checkAngualarLimitVelocity(targetAngularVel - angularVelStepSize);

    _sendCommand();
  }

  Future<void> stop() async {
    targetLinearVel = 0;
    controlLinearVel = 0;
    targetAngularVel = 0;
    controlAngularVel = 0;

    _sendCommand();
  }
}
