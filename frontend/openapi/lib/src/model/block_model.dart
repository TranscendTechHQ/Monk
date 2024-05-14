//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/link_meta_model.dart';
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

     this.childThreadId = '',

    required  this.content,

     this.createdAt,

     this.creatorId = 'unknown id',

     this.image,

     this.lastModified,

     this.linkMeta,

     this.mainThreadId = '',

     this.position = 0,

     this.taskStatus = 'todo',

     this.tenantId = '',
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



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
    
    name: r'image',
    required: false,
    includeIfNull: false
  )


  final String? image;



  @JsonKey(
    
    name: r'last_modified',
    required: false,
    includeIfNull: false
  )


  final DateTime? lastModified;



  @JsonKey(
    
    name: r'link_meta',
    required: false,
    includeIfNull: false
  )


  final LinkMetaModel? linkMeta;



  @JsonKey(
    defaultValue: '',
    name: r'main_thread_id',
    required: false,
    includeIfNull: false
  )


  final String? mainThreadId;



  @JsonKey(
    defaultValue: 0,
    name: r'position',
    required: false,
    includeIfNull: false
  )


  final int? position;



  @JsonKey(
    defaultValue: 'todo',
    name: r'task_status',
    required: false,
    includeIfNull: false
  )


  final String? taskStatus;



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
     other.childThreadId == childThreadId &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creatorId == creatorId &&
     other.image == image &&
     other.lastModified == lastModified &&
     other.linkMeta == linkMeta &&
     other.mainThreadId == mainThreadId &&
     other.position == position &&
     other.taskStatus == taskStatus &&
     other.tenantId == tenantId;

  @override
  int get hashCode =>
    id.hashCode +
    childThreadId.hashCode +
    content.hashCode +
    createdAt.hashCode +
    creatorId.hashCode +
    (image == null ? 0 : image.hashCode) +
    lastModified.hashCode +
    (linkMeta == null ? 0 : linkMeta.hashCode) +
    mainThreadId.hashCode +
    position.hashCode +
    taskStatus.hashCode +
    tenantId.hashCode;

  factory BlockModel.fromJson(Map<String, dynamic> json) => _$BlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

