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
          lastLogin: $checkedConvert('last_login', (v) => v as String?),
          picture: $checkedConvert('picture', (v) => v as String?),
          sessionHandle: $checkedConvert('sessionHandle', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'lastLogin': 'last_login'},
    );

Map<String, dynamic> _$SessionInfoToJson(SessionInfo instance) {
  final val = <String, dynamic>{
    'accessTokenPayload': instance.accessTokenPayload,
    'email': instance.email,
    'fullName': instance.fullName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('last_login', instance.lastLogin);
  writeNotNull('picture', instance.picture);
  val['sessionHandle'] = instance.sessionHandle;
  val['userId'] = instance.userId;
  return val;
}
