//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/thread_type.dart';
import 'package:openapi/src/model/block_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadModel {
  /// Returns a new [ThreadModel] instance.
  ThreadModel({

     this.id,

    required  this.creator,

     this.createdDate,

    required  this.type,

    required  this.title,

     this.content,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    
    name: r'creator',
    required: true,
    includeIfNull: false
  )


  final String creator;



  @JsonKey(
    
    name: r'created_date',
    required: false,
    includeIfNull: false
  )


  final DateTime? createdDate;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false
  )


  final ThreadType type;



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
  bool operator ==(Object other) => identical(this, other) || other is ThreadModel &&
     other.id == id &&
     other.creator == creator &&
     other.createdDate == createdDate &&
     other.type == type &&
     other.title == title &&
     other.content == content;

  @override
  int get hashCode =>
    id.hashCode +
    creator.hashCode +
    createdDate.hashCode +
    type.hashCode +
    title.hashCode +
    content.hashCode;

  factory ThreadModel.fromJson(Map<String, dynamic> json) => _$ThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

