import 'package:flutter/material.dart';
import 'package:robot_control/teleop/teleop_utils.dart';
import 'package:robot_control/teleop/teleop_zenoh.dart';
import 'package:robot_control/teleop/teleoperation_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teleop Turtlebot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Teleop Turtlebot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TeleoperationInterface _node = TeleopZenoh('localhost:7447');
  final TeleopUtils _robotUtils = TeleopUtils();
  double _controlLinearVel = 0;
  double _controlAngularVel = 0;
  double _targetLinearVel = 0;
  double _targetAngualarVel = 0;

  static const _linearVelStepSize = 0.01;
  static const _angularVelStepSize = 0.1;

  void _accelerate() {
    setState(() {
      _targetLinearVel = _robotUtils
          .checkLinearLimitVelocity(_targetLinearVel + _linearVelStepSize);
    });

    _sendCommand();
  }

  void _decelerate() {
    setState(() {
      _targetLinearVel = _robotUtils
          .checkLinearLimitVelocity(_targetLinearVel + _linearVelStepSize);
    });

    _sendCommand();
  }

  void _leftwards() {
    setState(() {
      _targetAngualarVel = _robotUtils
          .checkAngualarLimitVelocity(_targetAngualarVel + _angularVelStepSize);
    });

    _sendCommand();
  }

  void _rightwards() {
    setState(() {
      _targetAngualarVel = _robotUtils
          .checkAngualarLimitVelocity(_targetAngualarVel - _angularVelStepSize);
    });

    _sendCommand();
  }

  void _stop() {
    setState(() {
      _targetLinearVel = 0;
      _controlLinearVel = 0;
      _targetAngualarVel = 0;
      _controlAngularVel = 0;
    });

    _sendCommand();
  }

  Future<void> _sendCommand() async {
    _controlLinearVel = _robotUtils.makeSimpleProfile(
        _controlLinearVel, _targetLinearVel, (_linearVelStepSize / 2.0));

    _controlAngularVel = _robotUtils.makeSimpleProfile(
        _controlAngularVel, _targetAngualarVel, (_angularVelStepSize / 2.0));

    await _node.move(
        'rt/turtle1/cmd_vel', _controlLinearVel, _controlAngularVel);
  }

  final SizedBox _box = const SizedBox(
    height: 5,
    width: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _accelerate,
              child: const Icon(Icons.arrow_upward),
            ),
            _box,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _leftwards,
                  child: const Icon(Icons.arrow_back),
                ),
                _box,
                ElevatedButton(
                    onPressed: _stop, child: const Icon(Icons.cancel_outlined)),
                _box,
                ElevatedButton(
                    onPressed: _rightwards,
                    child: const Icon(Icons.arrow_forward))
              ],
            ),
            _box,
            ElevatedButton(
              onPressed: _decelerate,
              child: const Icon(Icons.arrow_downward),
            ),
            _box,
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
