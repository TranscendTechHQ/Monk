//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'channel_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ChannelModel {
  /// Returns a new [ChannelModel] instance.
  ChannelModel({

    required  this.id,

    required  this.name,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false
  )


  final String name;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ChannelModel &&
     other.id == id &&
     other.name == name;

  @override
  int get hashCode =>
    id.hashCode +
    name.hashCode;

  factory ChannelModel.fromJson(Map<String, dynamic> json) => _$ChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

