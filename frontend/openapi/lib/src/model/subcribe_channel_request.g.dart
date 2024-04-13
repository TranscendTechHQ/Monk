// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcribe_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubcribeChannelRequest _$SubcribeChannelRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubcribeChannelRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['channel_ids'],
        );
        final val = SubcribeChannelRequest(
          channelIds: $checkedConvert('channel_ids',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {'channelIds': 'channel_ids'},
    );

Map<String, dynamic> _$SubcribeChannelRequestToJson(
        SubcribeChannelRequest instance) =>
    <String, dynamic>{
      'channel_ids': instance.channelIds,
    };
