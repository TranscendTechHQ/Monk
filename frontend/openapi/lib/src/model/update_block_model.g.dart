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
          content: $checkedConvert('content', (v) => v),
          metadata: $checkedConvert('metadata', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateBlockModelToJson(UpdateBlockModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content);
  writeNotNull('metadata', instance.metadata);
  return val;
}
