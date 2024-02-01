// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockModel _$BlockModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'BlockModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['content'],
        );
        final val = BlockModel(
          id: $checkedConvert('_id', (v) => v as String?),
          content: $checkedConvert('content', (v) => v as String),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'id': '_id', 'createdAt': 'created_at'},
    );

Map<String, dynamic> _$BlockModelToJson(BlockModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['content'] = instance.content;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}
