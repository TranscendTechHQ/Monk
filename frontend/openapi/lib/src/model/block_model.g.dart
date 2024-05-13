// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockModel _$BlockModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'BlockModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['content'],
        );
        final val = BlockModel(
          id: $checkedConvert('_id', (v) => v as String?),
          childThreadId:
              $checkedConvert('child_thread_id', (v) => v as String? ?? ''),
          content: $checkedConvert('content', (v) => v as String),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          creatorId: $checkedConvert(
              'creator_id', (v) => v as String? ?? 'unknown id'),
          image: $checkedConvert('image', (v) => v as String?),
          lastModified: $checkedConvert('last_modified',
              (v) => v == null ? null : DateTime.parse(v as String)),
          mainThreadId:
              $checkedConvert('main_thread_id', (v) => v as String? ?? ''),
          position:
              $checkedConvert('position', (v) => (v as num?)?.toInt() ?? 0),
          taskStatus:
              $checkedConvert('task_status', (v) => v as String? ?? 'todo'),
          tenantId: $checkedConvert('tenant_id', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'childThreadId': 'child_thread_id',
        'createdAt': 'created_at',
        'creatorId': 'creator_id',
        'lastModified': 'last_modified',
        'mainThreadId': 'main_thread_id',
        'taskStatus': 'task_status',
        'tenantId': 'tenant_id'
      },
    );

Map<String, dynamic> _$BlockModelToJson(BlockModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('child_thread_id', instance.childThreadId);
  val['content'] = instance.content;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('creator_id', instance.creatorId);
  writeNotNull('image', instance.image);
  writeNotNull('last_modified', instance.lastModified?.toIso8601String());
  writeNotNull('main_thread_id', instance.mainThreadId);
  writeNotNull('position', instance.position);
  writeNotNull('task_status', instance.taskStatus);
  writeNotNull('tenant_id', instance.tenantId);
  return val;
}
