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
          requiredKeys: const ['topic'],
        );
        final val = UpdateThreadTitleModel(
          topic: $checkedConvert('topic', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateThreadTitleModelToJson(
        UpdateThreadTitleModel instance) =>
    <String, dynamic>{
      'topic': instance.topic,
    };
