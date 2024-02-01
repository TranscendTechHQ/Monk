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
          date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ModelDateToJson(ModelDate instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
    };
