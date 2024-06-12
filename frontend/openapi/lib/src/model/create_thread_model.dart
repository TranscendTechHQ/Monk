//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/block_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_thread_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateThreadModel {
  /// Returns a new [CreateThreadModel] instance.
  CreateThreadModel({

     this.content,

    required  this.topic,

    required  this.type,
  });

  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockModel>? content;



  @JsonKey(
    
    name: r'topic',
    required: true,
    includeIfNull: false
  )


  final String topic;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false
  )


  final String type;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateThreadModel &&
     other.content == content &&
     other.topic == topic &&
     other.type == type;

  @override
  int get hashCode =>
    content.hashCode +
    topic.hashCode +
    type.hashCode;

  factory CreateThreadModel.fromJson(Map<String, dynamic> json) => _$CreateThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

