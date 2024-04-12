//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/channel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'composite_channel_list.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CompositeChannelList {
  /// Returns a new [CompositeChannelList] instance.
  CompositeChannelList({

    required  this.id,

    required  this.publicChannels,

    required  this.subscribedChannels,
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'public_channels',
    required: true,
    includeIfNull: false
  )


  final List<ChannelModel> publicChannels;



  @JsonKey(
    
    name: r'subscribed_channels',
    required: true,
    includeIfNull: false
  )


  final List<ChannelModel> subscribedChannels;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CompositeChannelList &&
     other.id == id &&
     other.publicChannels == publicChannels &&
     other.subscribedChannels == subscribedChannels;

  @override
  int get hashCode =>
    id.hashCode +
    publicChannels.hashCode +
    subscribedChannels.hashCode;

  factory CompositeChannelList.fromJson(Map<String, dynamic> json) => _$CompositeChannelListFromJson(json);

  Map<String, dynamic> toJson() => _$CompositeChannelListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

