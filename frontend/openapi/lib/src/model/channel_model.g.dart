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
          requiredKeys: const ['creator', 'id', 'name'],
        );
        final val = ChannelModel(
          creator: $checkedConvert('creator', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'creator': instance.creator,
      'id': instance.id,
      'name': instance.name,
    };
