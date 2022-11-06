// This file initializes the dynamic library and connects it with the stub
// generated by flutter_rust_bridge_codegen.

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'bridge_generated.web.dart';

export 'bridge_definitions.dart';

const root = 'pkg/robot_node';
final robotNode = RobotNodeImpl.wasm(
  WasmModule.initialize(kind: const Modules.noModules(root: root)),
);
