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
     other.sessionHandle == sessionHandle &&
     other.userId == userId;

  @override
  int get hashCode =>
    accessTokenPayload.hashCode +
    email.hashCode +
    sessionHandle.hashCode +
    userId.hashCode;

  factory SessionInfo.fromJson(Map<String, dynamic> json) => _$SessionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SessionInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

