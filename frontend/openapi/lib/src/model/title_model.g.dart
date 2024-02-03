// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TitleModel _$TitleModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TitleModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['titles'],
        );
        final val = TitleModel(
          titles: $checkedConvert('titles',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$TitleModelToJson(TitleModel instance) =>
    <String, dynamic>{
      'titles': instance.titles,
    };
