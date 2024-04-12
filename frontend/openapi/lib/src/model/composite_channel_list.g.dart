// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite_channel_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompositeChannelList _$CompositeChannelListFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CompositeChannelList',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['_id', 'public_channels', 'subscribed_channels'],
        );
        final val = CompositeChannelList(
          id: $checkedConvert('_id', (v) => v as String),
          publicChannels: $checkedConvert(
              'public_channels',
              (v) => (v as List<dynamic>)
                  .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
          subscribedChannels: $checkedConvert(
              'subscribed_channels',
              (v) => (v as List<dynamic>)
                  .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'publicChannels': 'public_channels',
        'subscribedChannels': 'subscribed_channels'
      },
    );

Map<String, dynamic> _$CompositeChannelListToJson(
        CompositeChannelList instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'public_channels':
          instance.publicChannels.map((e) => e.toJson()).toList(),
      'subscribed_channels':
          instance.subscribedChannels.map((e) => e.toJson()).toList(),
    };
