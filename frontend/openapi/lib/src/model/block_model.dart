//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'block_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BlockModel {
  /// Returns a new [BlockModel] instance.
  BlockModel({

     this.id,

     this.blockPosInChild = 0,

     this.childThreadId = '',

    required  this.content,

     this.createdAt,

     this.creatorId = 'unknown id',

     this.lastModified,

     this.mainThreadId = '',

     this.position,

     this.tenantId = '',
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    defaultValue: 0,
    name: r'block_pos_in_child',
    required: false,
    includeIfNull: false
  )


  final int? blockPosInChild;



  @JsonKey(
    defaultValue: '',
    name: r'child_thread_id',
    required: false,
    includeIfNull: false
  )


  final String? childThreadId;



  @JsonKey(
    
    name: r'content',
    required: true,
    includeIfNull: false
  )


  final String content;



  @JsonKey(
    
    name: r'created_at',
    required: false,
    includeIfNull: false
  )


  final DateTime? createdAt;



  @JsonKey(
    defaultValue: 'unknown id',
    name: r'creator_id',
    required: false,
    includeIfNull: false
  )


  final String? creatorId;



  @JsonKey(
    
    name: r'last_modified',
    required: false,
    includeIfNull: false
  )


  final DateTime? lastModified;



  @JsonKey(
    defaultValue: '',
    name: r'main_thread_id',
    required: false,
    includeIfNull: false
  )


  final String? mainThreadId;



  @JsonKey(
    
    name: r'position',
    required: false,
    includeIfNull: false
  )


  final int? position;



  @JsonKey(
    defaultValue: '',
    name: r'tenant_id',
    required: false,
    includeIfNull: false
  )


  final String? tenantId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockModel &&
     other.id == id &&
     other.blockPosInChild == blockPosInChild &&
     other.childThreadId == childThreadId &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creatorId == creatorId &&
     other.lastModified == lastModified &&
     other.mainThreadId == mainThreadId &&
     other.position == position &&
     other.tenantId == tenantId;

  @override
  int get hashCode =>
    id.hashCode +
    blockPosInChild.hashCode +
    childThreadId.hashCode +
    content.hashCode +
    createdAt.hashCode +
    creatorId.hashCode +
    lastModified.hashCode +
    mainThreadId.hashCode +
    (position == null ? 0 : position.hashCode) +
    tenantId.hashCode;

  factory BlockModel.fromJson(Map<String, dynamic> json) => _$BlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

