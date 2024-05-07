// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadModel _$ThreadModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ThreadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'creator_id',
            'last_modified',
            'tenant_id',
            'title',
            'type'
          ],
        );
        final val = ThreadModel(
          id: $checkedConvert('_id', (v) => v as String?),
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => BlockModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          creatorId: $checkedConvert('creator_id', (v) => v as String),
          headline: $checkedConvert('headline', (v) => v as String?),
          lastModified: $checkedConvert('last_modified', (v) => v as String),
          numBlocks:
              $checkedConvert('num_blocks', (v) => (v as num?)?.toInt() ?? 0),
          parentBlockId:
              $checkedConvert('parent_block_id', (v) => v as String?),
          slackThreadTs: $checkedConvert('slack_thread_ts', (v) => v as num?),
          tenantId: $checkedConvert('tenant_id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'creatorId': 'creator_id',
        'lastModified': 'last_modified',
        'numBlocks': 'num_blocks',
        'parentBlockId': 'parent_block_id',
        'slackThreadTs': 'slack_thread_ts',
        'tenantId': 'tenant_id'
      },
    );

Map<String, dynamic> _$ThreadModelToJson(ThreadModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  val['creator_id'] = instance.creatorId;
  writeNotNull('headline', instance.headline);
  val['last_modified'] = instance.lastModified;
  writeNotNull('num_blocks', instance.numBlocks);
  writeNotNull('parent_block_id', instance.parentBlockId);
  writeNotNull('slack_thread_ts', instance.slackThreadTs);
  val['tenant_id'] = instance.tenantId;
  val['title'] = instance.title;
  val['type'] = instance.type;
  return val;
}
