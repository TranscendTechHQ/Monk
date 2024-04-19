//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_list.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserList {
  /// Returns a new [UserList] instance.
  UserList({

    required  this.users,
  });

  @JsonKey(
    
    name: r'users',
    required: true,
    includeIfNull: false
  )


  final List<UserModel> users;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UserList &&
     other.users == users;

  @override
  int get hashCode =>
    users.hashCode;

  factory UserList.fromJson(Map<String, dynamic> json) => _$UserListFromJson(json);

  Map<String, dynamic> toJson() => _$UserListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

