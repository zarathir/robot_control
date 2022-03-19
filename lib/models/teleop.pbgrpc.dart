///
//  Generated code. Do not modify.
//  source: teleop.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'teleop.pb.dart' as $0;
export 'teleop.pb.dart';

class TeleopClient extends $grpc.Client {
  static final _$sendCommand =
      $grpc.ClientMethod<$0.CommandRequest, $0.CommandAck>(
          '/teleop.Teleop/SendCommand',
          ($0.CommandRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.CommandAck.fromBuffer(value));

  TeleopClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.CommandAck> sendCommand($0.CommandRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendCommand, request, options: options);
  }
}

abstract class TeleopServiceBase extends $grpc.Service {
  $core.String get $name => 'teleop.Teleop';

  TeleopServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CommandRequest, $0.CommandAck>(
        'SendCommand',
        sendCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CommandRequest.fromBuffer(value),
        ($0.CommandAck value) => value.writeToBuffer()));
  }

  $async.Future<$0.CommandAck> sendCommand_Pre(
      $grpc.ServiceCall call, $async.Future<$0.CommandRequest> request) async {
    return sendCommand(call, await request);
  }

  $async.Future<$0.CommandAck> sendCommand(
      $grpc.ServiceCall call, $0.CommandRequest request);
}
