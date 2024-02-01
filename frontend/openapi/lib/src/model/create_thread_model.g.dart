// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateThreadModel _$CreateThreadModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateThreadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['type', 'title'],
        );
        final val = CreateThreadModel(
          type: $checkedConvert('type', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => BlockModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$CreateThreadModelToJson(CreateThreadModel instance) {
  final val = <String, dynamic>{
    'type': instance.type,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  return val;
}
