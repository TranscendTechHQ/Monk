// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribed_channel_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribedChannelList _$SubscribedChannelListFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscribedChannelList',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['_id', 'subscribed_channels'],
        );
        final val = SubscribedChannelList(
          id: $checkedConvert('_id', (v) => v as String),
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
        'subscribedChannels': 'subscribed_channels'
      },
    );

Map<String, dynamic> _$SubscribedChannelListToJson(
        SubscribedChannelList instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'subscribed_channels':
          instance.subscribedChannels.map((e) => e.toJson()).toList(),
    };
