// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ValidationError',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['loc', 'msg', 'type'],
        );
        final val = ValidationError(
          loc: $checkedConvert('loc', (v) => v),
          msg: $checkedConvert('msg', (v) => v),
          type: $checkedConvert('type', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('loc', instance.loc);
  writeNotNull('msg', instance.msg);
  writeNotNull('type', instance.type);
  return val;
}
