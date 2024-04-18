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
          requiredKeys: const ['thread_id', 'user_id'],
        );
        final val = UserThreadFlagModel(
          id: $checkedConvert('_id', (v) => v as String?),
          bookmark: $checkedConvert('bookmark', (v) => v as bool? ?? false),
          read: $checkedConvert('read', (v) => v as bool? ?? false),
          threadId: $checkedConvert('thread_id', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool? ?? false),
          upvote: $checkedConvert('upvote', (v) => v as bool? ?? false),
          userId: $checkedConvert('user_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
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
  writeNotNull('bookmark', instance.bookmark);
  writeNotNull('read', instance.read);
  val['thread_id'] = instance.threadId;
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('upvote', instance.upvote);
  val['user_id'] = instance.userId;
  return val;
}
