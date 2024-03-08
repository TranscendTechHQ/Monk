//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'session_info.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SessionInfo {
  /// Returns a new [SessionInfo] instance.
  SessionInfo({

    required  this.accessTokenPayload,

    required  this.email,

    required  this.fullName,

     this.lastLogin,

     this.picture,

    required  this.sessionHandle,

    required  this.userId,
  });

  @JsonKey(
    
    name: r'accessTokenPayload',
    required: true,
    includeIfNull: false
  )


  final Object accessTokenPayload;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false
  )


  final String email;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false
  )


  final String fullName;



  @JsonKey(
    
    name: r'last_login',
    required: false,
    includeIfNull: false
  )


  final String? lastLogin;



  @JsonKey(
    
    name: r'picture',
    required: false,
    includeIfNull: false
  )


  final String? picture;



  @JsonKey(
    
    name: r'sessionHandle',
    required: true,
    includeIfNull: false
  )


  final String sessionHandle;



  @JsonKey(
    
    name: r'userId',
    required: true,
    includeIfNull: false
  )


  final String userId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is SessionInfo &&
     other.accessTokenPayload == accessTokenPayload &&
     other.email == email &&
     other.fullName == fullName &&
     other.lastLogin == lastLogin &&
     other.picture == picture &&
     other.sessionHandle == sessionHandle &&
     other.userId == userId;

  @override
  int get hashCode =>
    accessTokenPayload.hashCode +
    email.hashCode +
    fullName.hashCode +
    lastLogin.hashCode +
    picture.hashCode +
    sessionHandle.hashCode +
    userId.hashCode;

  factory SessionInfo.fromJson(Map<String, dynamic> json) => _$SessionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

