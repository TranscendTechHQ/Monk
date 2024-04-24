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
          childId: $checkedConvert('child_id', (v) => v as String? ?? ''),
          content: $checkedConvert('content', (v) => v as String),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          creator: $checkedConvert(
              'creator', (v) => UserModel.fromJson(v as Map<String, dynamic>)),
          creatorId: $checkedConvert(
              'creator_id', (v) => v as String? ?? 'unknown id'),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'childId': 'child_id',
        'createdAt': 'created_at',
        'creatorId': 'creator_id'
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
  writeNotNull('child_id', instance.childId);
  val['content'] = instance.content;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  val['creator'] = instance.creator.toJson();
  writeNotNull('creator_id', instance.creatorId);
  return val;
}
