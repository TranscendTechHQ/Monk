//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'subcribe_channel_request.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SubcribeChannelRequest {
  /// Returns a new [SubcribeChannelRequest] instance.
  SubcribeChannelRequest({

    required  this.channelIds,
  });

  @JsonKey(
    
    name: r'channel_ids',
    required: true,
    includeIfNull: false
  )


  final List<String> channelIds;



  @override
  bool operator ==(Object other) => identical(this, other) || other is SubcribeChannelRequest &&
     other.channelIds == channelIds;

  @override
  int get hashCode =>
    channelIds.hashCode;

  factory SubcribeChannelRequest.fromJson(Map<String, dynamic> json) => _$SubcribeChannelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubcribeChannelRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

