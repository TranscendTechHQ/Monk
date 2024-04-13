// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_channel_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicChannelList _$PublicChannelListFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PublicChannelList',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['public_channels'],
        );
        final val = PublicChannelList(
          publicChannels: $checkedConvert(
              'public_channels',
              (v) => (v as List<dynamic>)
                  .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {'publicChannels': 'public_channels'},
    );

Map<String, dynamic> _$PublicChannelListToJson(PublicChannelList instance) =>
    <String, dynamic>{
      'public_channels':
          instance.publicChannels.map((e) => e.toJson()).toList(),
    };
