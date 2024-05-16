// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_thread_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullThreadInfo _$FullThreadInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FullThreadInfo',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['_id', 'created_at', 'creator', 'title', 'type'],
        );
        final val = FullThreadInfo(
          id: $checkedConvert('_id', (v) => v as String),
          block: $checkedConvert(
              'block',
              (v) => v == null
                  ? null
                  : BlockModel.fromJson(v as Map<String, dynamic>)),
          bookmark: $checkedConvert('bookmark', (v) => v as bool?),
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      BlockWithCreator.fromJson(e as Map<String, dynamic>))
                  .toList()),
          createdAt: $checkedConvert('created_at', (v) => v as String),
          creator: $checkedConvert(
              'creator', (v) => UserModel.fromJson(v as Map<String, dynamic>)),
          defaultBlock: $checkedConvert(
              'default_block',
              (v) => v == null
                  ? null
                  : BlockWithCreator.fromJson(v as Map<String, dynamic>)),
          headline: $checkedConvert('headline', (v) => v as String?),
          lastModified: $checkedConvert('last_modified',
              (v) => v == null ? null : DateTime.parse(v as String)),
          numBlocks:
              $checkedConvert('num_blocks', (v) => (v as num?)?.toInt() ?? 0),
          parentBlockId:
              $checkedConvert('parent_block_id', (v) => v as String?),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
          unfollow: $checkedConvert('unfollow', (v) => v as bool?),
          unread: $checkedConvert('unread', (v) => v as bool?),
          upvote: $checkedConvert('upvote', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'defaultBlock': 'default_block',
        'lastModified': 'last_modified',
        'numBlocks': 'num_blocks',
        'parentBlockId': 'parent_block_id'
      },
    );

Map<String, dynamic> _$FullThreadInfoToJson(FullThreadInfo instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('block', instance.block?.toJson());
  writeNotNull('bookmark', instance.bookmark);
  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  val['created_at'] = instance.createdAt;
  val['creator'] = instance.creator.toJson();
  writeNotNull('default_block', instance.defaultBlock?.toJson());
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
