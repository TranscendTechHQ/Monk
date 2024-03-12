// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threads_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadsMetaData _$ThreadsMetaDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadsMetaData',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['metadata'],
        );
        final val = ThreadsMetaData(
          metadata: $checkedConvert(
              'metadata',
              (v) => (v as List<dynamic>)
                  .map(
                      (e) => ThreadMetaData.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ThreadsMetaDataToJson(ThreadsMetaData instance) =>
    <String, dynamic>{
      'metadata': instance.metadata.map((e) => e.toJson()).toList(),
    };
