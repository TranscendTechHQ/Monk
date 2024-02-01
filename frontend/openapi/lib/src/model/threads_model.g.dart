// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threads_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadsModel _$ThreadsModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadsModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['threads'],
        );
        final val = ThreadsModel(
          threads: $checkedConvert(
              'threads',
              (v) => (v as List<dynamic>)
                  .map((e) => ThreadModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ThreadsModelToJson(ThreadsModel instance) =>
    <String, dynamic>{
      'threads': instance.threads.map((e) => e.toJson()).toList(),
    };
