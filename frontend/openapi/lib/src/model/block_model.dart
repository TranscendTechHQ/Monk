//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/link_meta_model.dart';
import 'package:openapi/src/model/user_model.dart';
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

     this.assignedPos = 1,

     this.assignedThreadId,

     this.assignedTo,

     this.assignedToId,

     this.childThreadId = '',

    required  this.content,

     this.createdAt,

     this.creatorId = 'unknown id',

     this.dueDate,

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
    defaultValue: 1,
    name: r'assigned_pos',
    required: false,
    includeIfNull: false
  )


  final int? assignedPos;



  @JsonKey(
    
    name: r'assigned_thread_id',
    required: false,
    includeIfNull: false
  )


  final String? assignedThreadId;



  @JsonKey(
    
    name: r'assigned_to',
    required: false,
    includeIfNull: false
  )


  final UserModel? assignedTo;



  @JsonKey(
    
    name: r'assigned_to_id',
    required: false,
    includeIfNull: false
  )


  final String? assignedToId;



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
    
    name: r'due_date',
    required: false,
    includeIfNull: false
  )


  final DateTime? dueDate;



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
     other.assignedPos == assignedPos &&
     other.assignedThreadId == assignedThreadId &&
     other.assignedTo == assignedTo &&
     other.assignedToId == assignedToId &&
     other.childThreadId == childThreadId &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creatorId == creatorId &&
     other.dueDate == dueDate &&
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
    assignedPos.hashCode +
    (assignedThreadId == null ? 0 : assignedThreadId.hashCode) +
    (assignedTo == null ? 0 : assignedTo.hashCode) +
    (assignedToId == null ? 0 : assignedToId.hashCode) +
    childThreadId.hashCode +
    content.hashCode +
    createdAt.hashCode +
    creatorId.hashCode +
    (dueDate == null ? 0 : dueDate.hashCode) +
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

