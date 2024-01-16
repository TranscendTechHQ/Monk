// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockCollection _$BlockCollectionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BlockCollection',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['blocks'],
        );
        final val = BlockCollection(
          blocks: $checkedConvert('blocks', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$BlockCollectionToJson(BlockCollection instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('blocks', instance.blocks);
  return val;
}
