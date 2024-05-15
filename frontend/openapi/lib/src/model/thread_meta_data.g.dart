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
          requiredKeys: const ['_id', 'created_at', 'creator', 'title', 'type'],
        );
        final val = ThreadMetaData(
          id: $checkedConvert('_id', (v) => v as String),
          bookmark: $checkedConvert('bookmark', (v) => v as bool? ?? false),
          createdAt: $checkedConvert('created_at', (v) => v as String),
          creator: $checkedConvert(
              'creator', (v) => UserModel.fromJson(v as Map<String, dynamic>)),
          headline: $checkedConvert('headline', (v) => v as String?),
          lastModified: $checkedConvert('last_modified',
              (v) => v == null ? null : DateTime.parse(v as String)),
          numBlocks:
              $checkedConvert('num_blocks', (v) => (v as num?)?.toInt() ?? 0),
          parentBlockId:
              $checkedConvert('parent_block_id', (v) => v as String?),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool? ?? false),
          unread: $checkedConvert('unread', (v) => v as bool? ?? false),
          upvote: $checkedConvert('upvote', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'lastModified': 'last_modified',
        'numBlocks': 'num_blocks',
        'parentBlockId': 'parent_block_id'
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
  val['created_at'] = instance.createdAt;
  val['creator'] = instance.creator.toJson();
  writeNotNull('headline', instance.headline);
  writeNotNull('last_modified', instance.lastModified?.toIso8601String());
  writeNotNull('num_blocks', instance.numBlocks);
  writeNotNull('parent_block_id', instance.parentBlockId);
  val['title'] = instance.title;
  val['type'] = instance.type;
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('unread', instance.unread);
  writeNotNull('upvote', instance.upvote);
  return val;
}
