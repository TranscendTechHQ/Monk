// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_thread_read_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateThreadReadModel _$CreateThreadReadModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateThreadReadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['status', 'thread_id'],
        );
        final val = CreateThreadReadModel(
          status: $checkedConvert('status', (v) => v as bool),
          threadId: $checkedConvert('thread_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'threadId': 'thread_id'},
    );

Map<String, dynamic> _$CreateThreadReadModelToJson(
        CreateThreadReadModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'thread_id': instance.threadId,
    };
