// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SessionInfo',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'accessTokenPayload',
            'email',
            'fullName',
            'sessionHandle',
            'userId'
          ],
        );
        final val = SessionInfo(
          accessTokenPayload:
              $checkedConvert('accessTokenPayload', (v) => v as Object),
          email: $checkedConvert('email', (v) => v as String),
          fullName: $checkedConvert('fullName', (v) => v as String),
          sessionHandle: $checkedConvert('sessionHandle', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) =>
    <String, dynamic>{
      'accessTokenPayload': instance.accessTokenPayload,
      'email': instance.email,
      'fullName': instance.fullName,
      'sessionHandle': instance.sessionHandle,
      'userId': instance.userId,
    };
