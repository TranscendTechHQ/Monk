// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateThreadModel _$UpdateThreadModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateThreadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['content'],
        );
        final val = UpdateThreadModel(
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>)
                  .map((e) => BlockModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateThreadModelToJson(UpdateThreadModel instance) =>
    <String, dynamic>{
      'content': instance.content.map((e) => e.toJson()).toList(),
    };
