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
          requiredKeys: const ['content', 'main_thread_id'],
        );
        final val = CreateBlockModel(
          content: $checkedConvert('content', (v) => v as String),
          image: $checkedConvert('image', (v) => v as String?),
          mainThreadId: $checkedConvert('main_thread_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'mainThreadId': 'main_thread_id'},
    );

Map<String, dynamic> _$CreateBlockModelToJson(CreateBlockModel instance) {
  final val = <String, dynamic>{
    'content': instance.content,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image', instance.image);
  val['main_thread_id'] = instance.mainThreadId;
  return val;
}
