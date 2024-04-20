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
          bookmark: $checkedConvert('bookmark', (v) => v as bool? ?? false),
          read: $checkedConvert('read', (v) => v as bool? ?? false),
          threadId: $checkedConvert('thread_id', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool? ?? false),
          upvote: $checkedConvert('upvote', (v) => v as bool? ?? false),
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
  writeNotNull('read', instance.read);
  val['thread_id'] = instance.threadId;
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('upvote', instance.upvote);
  return val;
}
