// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PositionModel',
      json,
      ($checkedConvert) {
        final val = PositionModel(
          position:
              $checkedConvert('position', (v) => (v as num?)?.toInt() ?? 0),
          threadId: $checkedConvert('thread_id', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {'threadId': 'thread_id'},
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('position', instance.position);
  writeNotNull('thread_id', instance.threadId);
  return val;
}
