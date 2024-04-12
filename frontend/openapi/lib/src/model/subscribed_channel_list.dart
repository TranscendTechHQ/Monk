//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/channel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscribed_channel_list.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubscribedChannelList {
  /// Returns a new [SubscribedChannelList] instance.
  SubscribedChannelList({

    required  this.id,

    required  this.subscribedChannels,
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'subscribed_channels',
    required: true,
    includeIfNull: false
  )


  final List<ChannelModel> subscribedChannels;



  @override
  bool operator ==(Object other) => identical(this, other) || other is SubscribedChannelList &&
     other.id == id &&
     other.subscribedChannels == subscribedChannels;

  @override
  int get hashCode =>
    id.hashCode +
    subscribedChannels.hashCode;

  factory SubscribedChannelList.fromJson(Map<String, dynamic> json) => _$SubscribedChannelListFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribedChannelListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

