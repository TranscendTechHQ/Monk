// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_block_position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBlockPositionModel _$UpdateBlockPositionModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateBlockPositionModel',
      json,
      ($checkedConvert) {
        final val = UpdateBlockPositionModel(
          blockId: $checkedConvert('block_id', (v) => v as String? ?? ''),
          newPosition:
              $checkedConvert('new_position', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {'blockId': 'block_id', 'newPosition': 'new_position'},
    );

Map<String, dynamic> _$UpdateBlockPositionModelToJson(
    UpdateBlockPositionModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('block_id', instance.blockId);
  writeNotNull('new_position', instance.newPosition);
  return val;
}
