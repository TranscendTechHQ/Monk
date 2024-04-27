// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBlockModel _$CreateBlockModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateBlockModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['content', 'parent_thread_id'],
        );
        final val = CreateBlockModel(
          content: $checkedConvert('content', (v) => v as String),
          parentThreadId:
              $checkedConvert('parent_thread_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'parentThreadId': 'parent_thread_id'},
    );

Map<String, dynamic> _$CreateBlockModelToJson(CreateBlockModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'parent_thread_id': instance.parentThreadId,
    };
