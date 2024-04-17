//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subscribe_channel_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscribeChannelRequest {
  /// Returns a new [SubscribeChannelRequest] instance.
  SubscribeChannelRequest({

    required  this.channelIds,
  });

  @JsonKey(
    
    name: r'channel_ids',
    required: true,
    includeIfNull: false
  )


  final List<String> channelIds;



  @override
  bool operator ==(Object other) => identical(this, other) || other is SubscribeChannelRequest &&
     other.channelIds == channelIds;

  @override
  int get hashCode =>
    channelIds.hashCode;

  factory SubscribeChannelRequest.fromJson(Map<String, dynamic> json) => _$SubscribeChannelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeChannelRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

