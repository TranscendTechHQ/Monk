// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_with_creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockWithCreator _$BlockWithCreatorFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'BlockWithCreator',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['content', 'creator'],
        );
        final val = BlockWithCreator(
          id: $checkedConvert('_id', (v) => v as String?),
          blockPosInChild: $checkedConvert(
              'block_pos_in_child', (v) => (v as num?)?.toInt() ?? 0),
          blockPosInParent: $checkedConvert(
              'block_pos_in_parent', (v) => (v as num?)?.toInt() ?? 0),
          childId: $checkedConvert('child_id', (v) => v as String? ?? ''),
          childThreadId:
              $checkedConvert('child_thread_id', (v) => v as String? ?? ''),
          content: $checkedConvert('content', (v) => v as String),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          creator: $checkedConvert(
              'creator', (v) => UserModel.fromJson(v as Map<String, dynamic>)),
          creatorId: $checkedConvert(
              'creator_id', (v) => v as String? ?? 'unknown id'),
          lastModified: $checkedConvert('last_modified',
              (v) => v == null ? null : DateTime.parse(v as String)),
          parentThreadId:
              $checkedConvert('parent_thread_id', (v) => v as String? ?? ''),
          position: $checkedConvert(
              'position',
              (v) => (v as List<dynamic>?)
                  ?.map(
                      (e) => PositionModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          tenantId: $checkedConvert('tenant_id', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'blockPosInChild': 'block_pos_in_child',
        'blockPosInParent': 'block_pos_in_parent',
        'childId': 'child_id',
        'childThreadId': 'child_thread_id',
        'createdAt': 'created_at',
        'creatorId': 'creator_id',
        'lastModified': 'last_modified',
        'parentThreadId': 'parent_thread_id',
        'tenantId': 'tenant_id'
      },
    );

Map<String, dynamic> _$BlockWithCreatorToJson(BlockWithCreator instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('block_pos_in_child', instance.blockPosInChild);
  writeNotNull('block_pos_in_parent', instance.blockPosInParent);
  writeNotNull('child_id', instance.childId);
  writeNotNull('child_thread_id', instance.childThreadId);
  val['content'] = instance.content;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  val['creator'] = instance.creator.toJson();
  writeNotNull('creator_id', instance.creatorId);
  writeNotNull('last_modified', instance.lastModified?.toIso8601String());
  writeNotNull('parent_thread_id', instance.parentThreadId);
  writeNotNull('position', instance.position?.map((e) => e.toJson()).toList());
  writeNotNull('tenant_id', instance.tenantId);
  return val;
}
