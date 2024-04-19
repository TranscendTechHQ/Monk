// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_thread_title_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateThreadTitleModel _$UpdateThreadTitleModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateThreadTitleModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['title'],
        );
        final val = UpdateThreadTitleModel(
          title: $checkedConvert('title', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateThreadTitleModelToJson(
        UpdateThreadTitleModel instance) =>
    <String, dynamic>{
      'title': instance.title,
    };
