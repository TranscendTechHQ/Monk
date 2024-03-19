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
          childId: $checkedConvert('child_id', (v) => v as String? ?? ''),
          content: $checkedConvert('content', (v) => v as String),
          createdAt: $checkedConvert('created_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
          createdBy: $checkedConvert(
              'created_by', (v) => v as String? ?? 'unknown user'),
          creatorEmail: $checkedConvert(
              'creator_email', (v) => v as String? ?? 'unknown email'),
          creatorId: $checkedConvert(
              'creator_id', (v) => v as String? ?? 'unknown id'),
          creatorPicture: $checkedConvert(
              'creator_picture', (v) => v as String? ?? 'unknown picture link'),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'childId': 'child_id',
        'createdAt': 'created_at',
        'createdBy': 'created_by',
        'creatorEmail': 'creator_email',
        'creatorId': 'creator_id',
        'creatorPicture': 'creator_picture'
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
  writeNotNull('child_id', instance.childId);
  val['content'] = instance.content;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('created_by', instance.createdBy);
  writeNotNull('creator_email', instance.creatorEmail);
  writeNotNull('creator_id', instance.creatorId);
  writeNotNull('creator_picture', instance.creatorPicture);
  return val;
}
