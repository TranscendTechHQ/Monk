//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_map.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserMap {
  /// Returns a new [UserMap] instance.
  UserMap({
    required this.users,
  });

  @JsonKey(name: r'users', required: true, includeIfNull: false)
  final Map<String, UserModel>? users;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserMap && other.users == users;

  @override
  int get hashCode => (users == null ? 0 : users.hashCode);

  factory UserMap.fromJson(Map<String, dynamic> json) =>
      _$UserMapFromJson(json);

  Map<String, dynamic> toJson() => _$UserMapToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
