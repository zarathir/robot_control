import 'dart:math';

import 'package:robot_control/ffi.dart';

class TeleopClientNode {
  static const _turtlebotMaxLinVel = 0.22;
  static const _turtlebotMaxAngVel = 2.84;

  static const _linearVelStepSize = 0.01;
  static const _angularVelStepSize = 0.1;

  double _targetLinearVel = 0;
  double _targetAngularVel = 0;
  double controlLinearVel = 0;
  double controlAngularVel = 0;

  String topic = "/test";

  TeleopClientNode(String cmdKey) {
    api.nodeHandle();
    topic = cmdKey;
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
    return _constrain(vel, -_turtlebotMaxLinVel, _turtlebotMaxLinVel);
  }

  double _checkAngualarLimitVelocity(double vel) {
    return _constrain(vel, -_turtlebotMaxAngVel, _turtlebotMaxAngVel);
  }

  Future<void> _sendCommand() async {
    controlLinearVel = _makeSimpleProfile(
        controlLinearVel, _targetLinearVel, (_linearVelStepSize / 2.0));

    controlAngularVel = _makeSimpleProfile(
        controlAngularVel, _targetAngularVel, (_angularVelStepSize / 2.0));

    var linear = Vector3(x: controlLinearVel, y: 0, z: 0);
    var angular = Vector3(x: 0, y: 0, z: controlAngularVel);

    var twist = OptionTwist(linear: linear, angular: angular);

    await api.publishMessage(topic: topic, data: twist);
  }

  Future<void> accelerate() async {
    _targetLinearVel =
        _checkLinearLimitVelocity(_targetLinearVel + _linearVelStepSize);

    await _sendCommand();
  }

  Future<void> decelerate() async {
    _targetLinearVel =
        _checkLinearLimitVelocity(_targetLinearVel - _linearVelStepSize);

    await _sendCommand();
  }

  Future<void> leftwards() async {
    _targetAngularVel =
        _checkAngualarLimitVelocity(_targetAngularVel + _angularVelStepSize);

    await _sendCommand();
  }

  Future<void> rightwards() async {
    _targetAngularVel =
        _checkAngualarLimitVelocity(_targetAngularVel - _angularVelStepSize);

    await _sendCommand();
  }

  Future<void> stop() async {
    _targetLinearVel = 0;
    controlLinearVel = 0;
    _targetAngularVel = 0;
    controlAngularVel = 0;

    await _sendCommand();
  }
}
