//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserModel {
  /// Returns a new [UserModel] instance.
  UserModel({

    required  this.id,

     this.email = 'unknown email',

     this.lastLogin = 'unknown last login',

     this.name = 'unknown user',

     this.picture = 'unknown picture link',
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    defaultValue: 'unknown email',
    name: r'email',
    required: false,
    includeIfNull: false
  )


  final String? email;



  @JsonKey(
    defaultValue: 'unknown last login',
    name: r'last_login',
    required: false,
    includeIfNull: false
  )


  final String? lastLogin;



  @JsonKey(
    defaultValue: 'unknown user',
    name: r'name',
    required: false,
    includeIfNull: false
  )


  final String? name;



  @JsonKey(
    defaultValue: 'unknown picture link',
    name: r'picture',
    required: false,
    includeIfNull: false
  )


  final String? picture;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UserModel &&
     other.id == id &&
     other.email == email &&
     other.lastLogin == lastLogin &&
     other.name == name &&
     other.picture == picture;

  @override
  int get hashCode =>
    id.hashCode +
    email.hashCode +
    lastLogin.hashCode +
    name.hashCode +
    picture.hashCode;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

