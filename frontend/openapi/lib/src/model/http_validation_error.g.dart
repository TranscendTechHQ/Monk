// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'HTTPValidationError',
      json,
      ($checkedConvert) {
        final val = HTTPValidationError(
          detail: $checkedConvert('detail', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$HTTPValidationErrorToJson(HTTPValidationError instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('detail', instance.detail);
  return val;
}
