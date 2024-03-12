// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_headline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadHeadlineModel _$ThreadHeadlineModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadHeadlineModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['_id', 'headline', 'title'],
        );
        final val = ThreadHeadlineModel(
          id: $checkedConvert('_id', (v) => v as String),
          headline: $checkedConvert('headline', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': '_id'},
    );

Map<String, dynamic> _$ThreadHeadlineModelToJson(
        ThreadHeadlineModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'headline': instance.headline,
      'title': instance.title,
    };
