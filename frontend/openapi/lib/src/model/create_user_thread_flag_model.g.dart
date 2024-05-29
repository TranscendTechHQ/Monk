// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_thread_flag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserThreadFlagModel _$CreateUserThreadFlagModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateUserThreadFlagModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['thread_id'],
        );
        final val = CreateUserThreadFlagModel(
          bookmark: $checkedConvert('bookmark', (v) => v as bool?),
          mention: $checkedConvert('mention', (v) => v as bool?),
          threadId: $checkedConvert('thread_id', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool?),
          unread: $checkedConvert('unread', (v) => v as bool?),
          upvote: $checkedConvert('upvote', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {'threadId': 'thread_id'},
    );

Map<String, dynamic> _$CreateUserThreadFlagModelToJson(
    CreateUserThreadFlagModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('bookmark', instance.bookmark);
  writeNotNull('mention', instance.mention);
  val['thread_id'] = instance.threadId;
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('unread', instance.unread);
  writeNotNull('upvote', instance.upvote);
  return val;
}
