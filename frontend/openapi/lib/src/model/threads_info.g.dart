// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threads_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadsInfo _$ThreadsInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ThreadsInfo',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['info'],
        );
        final val = ThreadsInfo(
          info: $checkedConvert(
              'info', (v) => Map<String, String>.from(v as Map)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ThreadsInfoToJson(ThreadsInfo instance) =>
    <String, dynamic>{
      'info': instance.info,
    };
