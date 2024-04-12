//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/channel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_channel_list.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PublicChannelList {
  /// Returns a new [PublicChannelList] instance.
  PublicChannelList({

    required  this.publicChannels,
  });

  @JsonKey(
    
    name: r'public_channels',
    required: true,
    includeIfNull: false
  )


  final List<ChannelModel> publicChannels;



  @override
  bool operator ==(Object other) => identical(this, other) || other is PublicChannelList &&
     other.publicChannels == publicChannels;

  @override
  int get hashCode =>
    publicChannels.hashCode;

  factory PublicChannelList.fromJson(Map<String, dynamic> json) => _$PublicChannelListFromJson(json);

  Map<String, dynamic> toJson() => _$PublicChannelListToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

