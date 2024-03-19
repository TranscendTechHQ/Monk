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
            'parentBlockId',
            'parentThreadId',
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
          parentBlockId: $checkedConvert('parentBlockId', (v) => v as String),
          parentThreadId: $checkedConvert('parentThreadId', (v) => v as String),
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
  val['parentBlockId'] = instance.parentBlockId;
  val['parentThreadId'] = instance.parentThreadId;
  val['title'] = instance.title;
  val['type'] = instance.type;
  return val;
}
