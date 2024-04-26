// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBlockModel _$UpdateBlockModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateBlockModel',
      json,
      ($checkedConvert) {
        final val = UpdateBlockModel(
          blockPosInChild: $checkedConvert(
              'block_pos_in_child', (v) => (v as num?)?.toInt()),
          blockPosInParent: $checkedConvert(
              'block_pos_in_parent', (v) => (v as num?)?.toInt()),
          content: $checkedConvert('content', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'blockPosInChild': 'block_pos_in_child',
        'blockPosInParent': 'block_pos_in_parent'
      },
    );

Map<String, dynamic> _$UpdateBlockModelToJson(UpdateBlockModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('block_pos_in_child', instance.blockPosInChild);
  writeNotNull('block_pos_in_parent', instance.blockPosInParent);
  writeNotNull('content', instance.content);
  return val;
}
