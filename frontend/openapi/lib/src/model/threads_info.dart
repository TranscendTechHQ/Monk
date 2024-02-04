//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'threads_info.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadsInfo {
  /// Returns a new [ThreadsInfo] instance.
  ThreadsInfo({
    required this.info,
  });

  @JsonKey(name: r'info', required: true, includeIfNull: false)
  final Map<String, String>? info;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ThreadsInfo && other.info == info;

  @override
  int get hashCode => (info == null ? 0 : info.hashCode);

  factory ThreadsInfo.fromJson(Map<String, dynamic> json) =>
      _$ThreadsInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadsInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
