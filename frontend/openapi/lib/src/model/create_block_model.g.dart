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
        final val = CreateBlockModel(
          content: $checkedConvert('content', (v) => v as String?),
          parentThreadId:
              $checkedConvert('parent_thread_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'parentThreadId': 'parent_thread_id'},
    );

Map<String, dynamic> _$CreateBlockModelToJson(CreateBlockModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content);
  writeNotNull('parent_thread_id', instance.parentThreadId);
  return val;
}
