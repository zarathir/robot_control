import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:robot_control/ffi.dart';

import 'models/teleop.pbgrpc.dart';

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

  TeleopClientHandler(
      String host, ChannelCredentials credentials, Duration timeout) {
    channel = ClientChannel(host,
        port: 50051,
        options:
            ChannelOptions(credentials: credentials, idleTimeout: timeout));
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

// ignore: todo
// TODO handle exceptions properly for gRPC calls
  Future<void> _sendCommand(TeleopClient stub) async {
    controlLinearVel = _makeSimpleProfile(
        controlLinearVel, targetLinearVel, (linearVelStepSize / 2.0));

    controlAngularVel = _makeSimpleProfile(
        controlAngularVel, targetAngularVel, (angularVelStepSize / 2.0));

    var linear = Vector3(x: controlLinearVel, y: 0, z: 0);
    var angular = Vector3(x: 0, y: 0, z: controlAngularVel);

    try {
      stub.sendCommand(CommandRequest(linear: linear, angular: angular));
      api.pubTwist(
          cmdKey: "/rt/cmd_vel",
          linear: controlLinearVel,
          angular: controlAngularVel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> accelerate() async {
    var stub = TeleopClient(channel);

    targetLinearVel =
        _checkLinearLimitVelocity(targetLinearVel + linearVelStepSize);

    try {
      _sendCommand(stub);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> decelerate() async {
    var stub = TeleopClient(channel);

    targetLinearVel =
        _checkLinearLimitVelocity(targetLinearVel - linearVelStepSize);

    try {
      _sendCommand(stub);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leftwards() async {
    var stub = TeleopClient(channel);

    targetAngularVel =
        _checkAngualarLimitVelocity(targetAngularVel + angularVelStepSize);

    try {
      _sendCommand(stub);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rightwards() async {
    var stub = TeleopClient(channel);

    targetAngularVel =
        _checkAngualarLimitVelocity(targetAngularVel - angularVelStepSize);

    try {
      _sendCommand(stub);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> stop() async {
    var stub = TeleopClient(channel);

    targetLinearVel = 0;
    controlLinearVel = 0;
    targetAngularVel = 0;
    controlAngularVel = 0;

    try {
      _sendCommand(stub);
    } catch (e) {
      rethrow;
    }
  }
}
