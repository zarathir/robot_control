import 'dart:math';

class TeleopUtils {
  static const _turtlebotMaxLinVel = 0.22;
  static const _turtlebotMaxAngVel = 2.84;

  double makeSimpleProfile(double output, double input, double slop) {
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

  double checkLinearLimitVelocity(double vel) {
    return _constrain(vel, -_turtlebotMaxLinVel, _turtlebotMaxLinVel);
  }

  double checkAngualarLimitVelocity(double vel) {
    return _constrain(vel, -_turtlebotMaxAngVel, _turtlebotMaxAngVel);
  }
}
