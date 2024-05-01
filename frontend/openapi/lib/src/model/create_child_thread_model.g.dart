// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_child_thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChildThreadModel _$CreateChildThreadModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateChildThreadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'mainThreadId',
            'parentBlockId',
            'title',
            'type'
          ],
        );
        final val = CreateChildThreadModel(
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => BlockModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          mainThreadId: $checkedConvert('mainThreadId', (v) => v as String),
          parentBlockId: $checkedConvert('parentBlockId', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CreateChildThreadModelToJson(
    CreateChildThreadModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  val['mainThreadId'] = instance.mainThreadId;
  val['parentBlockId'] = instance.parentBlockId;
  val['title'] = instance.title;
  val['type'] = instance.type;
  return val;
}
