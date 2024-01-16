//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'validation_error.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ValidationError {
  /// Returns a new [ValidationError] instance.
  ValidationError({
    required this.loc,
    required this.msg,
    required this.type,
  });

  @JsonKey(name: r'loc', required: true, includeIfNull: false)
  final Object? loc;

  @JsonKey(name: r'msg', required: true, includeIfNull: false)
  final Object? msg;

  @JsonKey(name: r'type', required: true, includeIfNull: false)
  final Object? type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          other.loc == loc &&
          other.msg == msg &&
          other.type == type;

  @override
  int get hashCode =>
      (loc == null ? 0 : loc.hashCode) +
      (msg == null ? 0 : msg.hashCode) +
      (type == null ? 0 : type.hashCode);

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
