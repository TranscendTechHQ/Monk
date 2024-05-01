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
          bookmark: $checkedConvert('bookmark', (v) => v as bool? ?? false),
          createdDate: $checkedConvert('created_date', (v) => v as String),
          creator: $checkedConvert(
              'creator', (v) => UserModel.fromJson(v as Map<String, dynamic>)),
          headline: $checkedConvert('headline', (v) => v as String?),
          lastModified: $checkedConvert('last_modified',
              (v) => v == null ? null : DateTime.parse(v as String)),
          read: $checkedConvert('read', (v) => v as bool? ?? false),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool? ?? false),
          upvote: $checkedConvert('upvote', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdDate': 'created_date',
        'lastModified': 'last_modified'
      },
    );

Map<String, dynamic> _$ThreadMetaDataToJson(ThreadMetaData instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('bookmark', instance.bookmark);
  val['created_date'] = instance.createdDate;
  val['creator'] = instance.creator.toJson();
  writeNotNull('headline', instance.headline);
  writeNotNull('last_modified', instance.lastModified?.toIso8601String());
  writeNotNull('read', instance.read);
  val['title'] = instance.title;
  val['type'] = instance.type;
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('upvote', instance.upvote);
  return val;
}
