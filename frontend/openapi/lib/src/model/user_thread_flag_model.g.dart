// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_thread_flag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserThreadFlagModel _$UserThreadFlagModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserThreadFlagModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['tenant_id', 'thread_id', 'user_id'],
        );
        final val = UserThreadFlagModel(
          id: $checkedConvert('_id', (v) => v as String?),
          assigned: $checkedConvert('assigned', (v) => v as bool?),
          bookmark: $checkedConvert('bookmark', (v) => v as bool?),
          mention: $checkedConvert('mention', (v) => v as bool?),
          tenantId: $checkedConvert('tenant_id', (v) => v as String),
          threadId: $checkedConvert('thread_id', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool?),
          unread: $checkedConvert('unread', (v) => v as bool?),
          upvote: $checkedConvert('upvote', (v) => v as bool?),
          userId: $checkedConvert('user_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'tenantId': 'tenant_id',
        'threadId': 'thread_id',
        'userId': 'user_id'
      },
    );

Map<String, dynamic> _$UserThreadFlagModelToJson(UserThreadFlagModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('assigned', instance.assigned);
  writeNotNull('bookmark', instance.bookmark);
  writeNotNull('mention', instance.mention);
  val['tenant_id'] = instance.tenantId;
  val['thread_id'] = instance.threadId;
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('unread', instance.unread);
  writeNotNull('upvote', instance.upvote);
  val['user_id'] = instance.userId;
  return val;
}
