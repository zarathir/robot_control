import 'package:flutter/material.dart';
import 'package:robot_control/teleop_client_node.dart';

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
  TeleopClientHandler node = TeleopClientHandler('/rt/turtle1/cmd_vel');

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
              onPressed: () async => node.accelerate(),
              child: const Icon(Icons.arrow_upward),
            ),
            _box,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async => node.leftwards(),
                  child: const Icon(Icons.arrow_back),
                ),
                _box,
                ElevatedButton(
                    onPressed: () async => node.stop(),
                    child: const Icon(Icons.cancel_outlined)),
                _box,
                ElevatedButton(
                    onPressed: () async => node.rightwards(),
                    child: const Icon(Icons.arrow_forward))
              ],
            ),
            _box,
            ElevatedButton(
              onPressed: () async => node.decelerate(),
              child: const Icon(Icons.arrow_downward),
            ),
            _box,
            Text("linear.x: " + node.controlLinearVel.toString()),
            Text("angular.z: " + node.controlAngularVel.toString())
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
