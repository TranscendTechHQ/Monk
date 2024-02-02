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
          requiredKeys: const ['title', 'type'],
        );
        final val = CreateThreadModel(
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => BlockModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CreateThreadModelToJson(CreateThreadModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  val['title'] = instance.title;
  val['type'] = instance.type;
  return val;
}
