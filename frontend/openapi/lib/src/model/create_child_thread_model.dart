//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/block_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_child_thread_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateChildThreadModel {
  /// Returns a new [CreateChildThreadModel] instance.
  CreateChildThreadModel({

     this.assignedId,

     this.content,

    required  this.mainThreadId,

    required  this.parentBlockId,

    required  this.topic,

    required  this.type,
  });

  @JsonKey(
    
    name: r'assignedId',
    required: false,
    includeIfNull: false
  )


  final String? assignedId;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockModel>? content;



  @JsonKey(
    
    name: r'mainThreadId',
    required: true,
    includeIfNull: false
  )


  final String mainThreadId;



  @JsonKey(
    
    name: r'parentBlockId',
    required: true,
    includeIfNull: false
  )


  final String parentBlockId;



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
  bool operator ==(Object other) => identical(this, other) || other is CreateChildThreadModel &&
     other.assignedId == assignedId &&
     other.content == content &&
     other.mainThreadId == mainThreadId &&
     other.parentBlockId == parentBlockId &&
     other.topic == topic &&
     other.type == type;

  @override
  int get hashCode =>
    (assignedId == null ? 0 : assignedId.hashCode) +
    content.hashCode +
    mainThreadId.hashCode +
    parentBlockId.hashCode +
    topic.hashCode +
    type.hashCode;

  factory CreateChildThreadModel.fromJson(Map<String, dynamic> json) => _$CreateChildThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChildThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

