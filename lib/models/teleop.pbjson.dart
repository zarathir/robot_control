///
//  Generated code. Do not modify.
//  source: teleop.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use vector3Descriptor instead')
const Vector3$json = const {
  '1': 'Vector3',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
    const {'1': 'z', '3': 3, '4': 1, '5': 2, '10': 'z'},
  ],
};

/// Descriptor for `Vector3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vector3Descriptor = $convert.base64Decode(
    'CgdWZWN0b3IzEgwKAXgYASABKAJSAXgSDAoBeRgCIAEoAlIBeRIMCgF6GAMgASgCUgF6');
@$core.Deprecated('Use commandRequestDescriptor instead')
const CommandRequest$json = const {
  '1': 'CommandRequest',
  '2': const [
    const {
      '1': 'linear',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.teleop.Vector3',
      '10': 'linear'
    },
    const {
      '1': 'angular',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.teleop.Vector3',
      '10': 'angular'
    },
  ],
};

/// Descriptor for `CommandRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandRequestDescriptor = $convert.base64Decode(
    'Cg5Db21tYW5kUmVxdWVzdBInCgZsaW5lYXIYASABKAsyDy50ZWxlb3AuVmVjdG9yM1IGbGluZWFyEikKB2FuZ3VsYXIYAiABKAsyDy50ZWxlb3AuVmVjdG9yM1IHYW5ndWxhcg==');
@$core.Deprecated('Use commandAckDescriptor instead')
const CommandAck$json = const {
  '1': 'CommandAck',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CommandAck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandAckDescriptor = $convert
    .base64Decode('CgpDb21tYW5kQWNrEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');
