// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_headlines_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadHeadlinesModel _$ThreadHeadlinesModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadHeadlinesModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['headlines'],
        );
        final val = ThreadHeadlinesModel(
          headlines: $checkedConvert(
              'headlines',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      ThreadHeadlineModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ThreadHeadlinesModelToJson(
        ThreadHeadlinesModel instance) =>
    <String, dynamic>{
      'headlines': instance.headlines.map((e) => e.toJson()).toList(),
    };
