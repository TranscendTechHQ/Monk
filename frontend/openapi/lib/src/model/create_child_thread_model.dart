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

     this.content,

    required  this.parentBlockId,

    required  this.parentThreadId,

    required  this.title,

    required  this.type,
  });

  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockModel>? content;



  @JsonKey(
    
    name: r'parentBlockId',
    required: true,
    includeIfNull: false
  )


  final String parentBlockId;



  @JsonKey(
    
    name: r'parentThreadId',
    required: true,
    includeIfNull: false
  )


  final String parentThreadId;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false
  )


  final String title;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false
  )


  final String type;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateChildThreadModel &&
     other.content == content &&
     other.parentBlockId == parentBlockId &&
     other.parentThreadId == parentThreadId &&
     other.title == title &&
     other.type == type;

  @override
  int get hashCode =>
    content.hashCode +
    parentBlockId.hashCode +
    parentThreadId.hashCode +
    title.hashCode +
    type.hashCode;

  factory CreateChildThreadModel.fromJson(Map<String, dynamic> json) => _$CreateChildThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChildThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

