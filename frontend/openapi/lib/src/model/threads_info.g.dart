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
              'info',
              (v) => (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k, e as String),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$ThreadsInfoToJson(ThreadsInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('info', instance.info);
  return val;
}
