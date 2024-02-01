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

    required  this.type,

    required  this.title,

     this.content,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false
  )


  final String type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false
  )


  final String title;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockModel>? content;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateThreadModel &&
     other.type == type &&
     other.title == title &&
     other.content == content;

  @override
  int get hashCode =>
    type.hashCode +
    title.hashCode +
    content.hashCode;

  factory CreateThreadModel.fromJson(Map<String, dynamic> json) => _$CreateThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

