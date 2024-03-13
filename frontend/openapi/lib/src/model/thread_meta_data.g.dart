// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadMetaData _$ThreadMetaDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadMetaData',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            '_id',
            'created_date',
            'creator',
            'title',
            'type'
          ],
        );
        final val = ThreadMetaData(
          id: $checkedConvert('_id', (v) => v as String),
          createdDate: $checkedConvert('created_date', (v) => v as String),
          creator: $checkedConvert(
              'creator', (v) => Creator.fromJson(v as Map<String, dynamic>)),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': '_id', 'createdDate': 'created_date'},
    );

Map<String, dynamic> _$ThreadMetaDataToJson(ThreadMetaData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'created_date': instance.createdDate,
      'creator': instance.creator.toJson(),
      'title': instance.title,
      'type': instance.type,
    };
