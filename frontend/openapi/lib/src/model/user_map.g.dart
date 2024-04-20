// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMap _$UserMapFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserMap',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['users'],
        );
        final val = UserMap(
          users: $checkedConvert(
              'users',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        k, UserModel.fromJson(e as Map<String, dynamic>)),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserMapToJson(UserMap instance) => <String, dynamic>{
      'users': instance.users.map((k, e) => MapEntry(k, e.toJson())),
    };
