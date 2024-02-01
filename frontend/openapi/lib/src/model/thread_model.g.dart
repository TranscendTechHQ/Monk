// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadModel _$ThreadModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ThreadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['creator', 'type', 'title'],
        );
        final val = ThreadModel(
          id: $checkedConvert('_id', (v) => v as String?),
          creator: $checkedConvert('creator', (v) => v as String),
          createdDate: $checkedConvert('created_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
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
      fieldKeyMap: const {'id': '_id', 'createdDate': 'created_date'},
    );

Map<String, dynamic> _$ThreadModelToJson(ThreadModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['creator'] = instance.creator;
  writeNotNull('created_date', instance.createdDate?.toIso8601String());
  val['type'] = instance.type;
  val['title'] = instance.title;
  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  return val;
}
