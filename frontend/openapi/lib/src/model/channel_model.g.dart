// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ChannelModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['created_at', 'creator', 'id', 'name'],
        );
        final val = ChannelModel(
          createdAt: $checkedConvert('created_at', (v) => v as String),
          creator: $checkedConvert('creator', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'createdAt': 'created_at'},
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt,
      'creator': instance.creator,
      'id': instance.id,
      'name': instance.name,
    };
