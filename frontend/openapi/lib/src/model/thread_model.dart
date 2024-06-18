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

     this.assignedToId,

     this.content,

     this.createdAt,

    required  this.creatorId,

     this.headline,

    required  this.lastModified,

     this.numBlocks = 0,

     this.parentBlockId,

     this.slackThreadTs,

    required  this.tenantId,

    required  this.topic,

    required  this.type,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    
    name: r'assigned_to_id',
    required: false,
    includeIfNull: false
  )


  final String? assignedToId;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockModel>? content;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final DateTime? createdAt;



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
    
    name: r'last_modified',
    required: true,
    includeIfNull: false
  )


  final String lastModified;



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
    
    name: r'slack_thread_ts',
    required: false,
    includeIfNull: false
  )


  final num? slackThreadTs;



  @JsonKey(
    
    name: r'tenant_id',
    required: true,
    includeIfNull: false
  )


  final String tenantId;



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
  bool operator ==(Object other) => identical(this, other) || other is ThreadModel &&
     other.id == id &&
     other.assignedToId == assignedToId &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creatorId == creatorId &&
     other.headline == headline &&
     other.lastModified == lastModified &&
     other.numBlocks == numBlocks &&
     other.parentBlockId == parentBlockId &&
     other.slackThreadTs == slackThreadTs &&
     other.tenantId == tenantId &&
     other.topic == topic &&
     other.type == type;

  @override
  int get hashCode =>
    id.hashCode +
    (assignedToId == null ? 0 : assignedToId.hashCode) +
    content.hashCode +
    createdAt.hashCode +
    creatorId.hashCode +
    headline.hashCode +
    lastModified.hashCode +
    numBlocks.hashCode +
    (parentBlockId == null ? 0 : parentBlockId.hashCode) +
    (slackThreadTs == null ? 0 : slackThreadTs.hashCode) +
    tenantId.hashCode +
    topic.hashCode +
    type.hashCode;

  factory ThreadModel.fromJson(Map<String, dynamic> json) => _$ThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

