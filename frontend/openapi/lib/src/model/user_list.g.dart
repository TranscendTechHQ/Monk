// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserList _$UserListFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserList',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['users'],
        );
        final val = UserList(
          users: $checkedConvert(
              'users',
              (v) => (v as List<dynamic>)
                  .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserListToJson(UserList instance) => <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };
