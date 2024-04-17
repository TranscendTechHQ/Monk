// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeChannelRequest _$SubscribeChannelRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscribeChannelRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['channel_ids'],
        );
        final val = SubscribeChannelRequest(
          channelIds: $checkedConvert('channel_ids',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'channelIds': 'channel_ids'},
    );

Map<String, dynamic> _$SubscribeChannelRequestToJson(
        SubscribeChannelRequest instance) =>
    <String, dynamic>{
      'channel_ids': instance.channelIds,
    };
