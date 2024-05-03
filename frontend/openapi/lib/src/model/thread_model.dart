//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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

     this.content,

     this.createdDate,

    required  this.creatorId,

     this.headline,

     this.numBlocks = 0,

     this.parentBlockId,

    required  this.tenantId,

    required  this.title,

    required  this.type,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockModel>? content;



  @JsonKey(
    
    name: r'created_date',
    required: false,
    includeIfNull: false
  )


  final DateTime? createdDate;



  @JsonKey(
    
    name: r'creator_id',
    required: true,
    includeIfNull: false
  )


  final String creatorId;



  @JsonKey(
    
    name: r'headline',
    required: false,
    includeIfNull: false
  )


  final String? headline;



  @JsonKey(
    defaultValue: 0,
    name: r'num_blocks',
    required: false,
    includeIfNull: false
  )


  final int? numBlocks;



  @JsonKey(
    
    name: r'parent_block_id',
    required: false,
    includeIfNull: false
  )


  final String? parentBlockId;



  @JsonKey(
    
    name: r'tenant_id',
    required: true,
    includeIfNull: false
  )


  final String tenantId;



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
  bool operator ==(Object other) => identical(this, other) || other is ThreadModel &&
     other.id == id &&
     other.content == content &&
     other.createdDate == createdDate &&
     other.creatorId == creatorId &&
     other.headline == headline &&
     other.numBlocks == numBlocks &&
     other.parentBlockId == parentBlockId &&
     other.tenantId == tenantId &&
     other.title == title &&
     other.type == type;

  @override
  int get hashCode =>
    id.hashCode +
    content.hashCode +
    createdDate.hashCode +
    creatorId.hashCode +
    headline.hashCode +
    numBlocks.hashCode +
    parentBlockId.hashCode +
    tenantId.hashCode +
    title.hashCode +
    type.hashCode;

  factory ThreadModel.fromJson(Map<String, dynamic> json) => _$ThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

