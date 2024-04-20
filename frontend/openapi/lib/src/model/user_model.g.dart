// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['_id'],
        );
        final val = UserModel(
          id: $checkedConvert('_id', (v) => v as String),
          email:
              $checkedConvert('email', (v) => v as String? ?? 'unknown email'),
          lastLogin: $checkedConvert(
              'last_login', (v) => v as String? ?? 'unknown last login'),
          name: $checkedConvert('name', (v) => v as String? ?? 'unknown user'),
          picture: $checkedConvert(
              'picture', (v) => v as String? ?? 'unknown picture link'),
        );
        return val;
      },
      fieldKeyMap: const {'id': '_id', 'lastLogin': 'last_login'},
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('last_login', instance.lastLogin);
  writeNotNull('name', instance.name);
  writeNotNull('picture', instance.picture);
  return val;
}
