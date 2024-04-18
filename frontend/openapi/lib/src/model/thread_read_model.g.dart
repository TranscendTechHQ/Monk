// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_read_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadReadModel _$ThreadReadModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadReadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['email', 'thread_id'],
        );
        final val = ThreadReadModel(
          email: $checkedConvert('email', (v) => v as String),
          threadId: $checkedConvert('thread_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'threadId': 'thread_id'},
    );

Map<String, dynamic> _$ThreadReadModelToJson(ThreadReadModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'thread_id': instance.threadId,
    };
