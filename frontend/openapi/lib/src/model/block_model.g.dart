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
          id: $checkedConvert('_id', (v) => v),
          content: $checkedConvert('content', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          metadata: $checkedConvert('metadata', (v) => v),
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
  writeNotNull('content', instance.content);
  writeNotNull('created_at', instance.createdAt);
  writeNotNull('metadata', instance.metadata);
  return val;
}
