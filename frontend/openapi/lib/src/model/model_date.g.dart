// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelDate _$ModelDateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ModelDate',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['date'],
        );
        final val = ModelDate(
          date: $checkedConvert('date', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$ModelDateToJson(ModelDate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('date', instance.date);
  return val;
}
