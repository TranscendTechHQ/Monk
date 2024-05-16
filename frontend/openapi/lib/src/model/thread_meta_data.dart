//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/block_model.dart';
import 'package:openapi/src/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_meta_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadMetaData {
  /// Returns a new [ThreadMetaData] instance.
  ThreadMetaData({

    required  this.id,

     this.block,

     this.bookmark = false,

    required  this.createdAt,

    required  this.creator,

     this.headline,

     this.lastModified,

     this.numBlocks = 0,

     this.parentBlockId,

    required  this.title,

    required  this.type,

     this.unfollow = false,

     this.unread = true,

     this.upvote = false,
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'block',
    required: false,
    includeIfNull: false
  )


  final BlockModel? block;



  @JsonKey(
    defaultValue: false,
    name: r'bookmark',
    required: false,
    includeIfNull: false
  )


  final bool? bookmark;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: false
  )


  final String createdAt;



  @JsonKey(
    
    name: r'creator',
    required: true,
    includeIfNull: false
  )


  final UserModel creator;



  @JsonKey(
    
    name: r'headline',
    required: false,
    includeIfNull: false
  )


  final String? headline;



  @JsonKey(
    
    name: r'last_modified',
    required: false,
    includeIfNull: false
  )


  final DateTime? lastModified;



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



  @JsonKey(
    defaultValue: false,
    name: r'unfollow',
    required: false,
    includeIfNull: false
  )


  final bool? unfollow;



  @JsonKey(
    defaultValue: true,
    name: r'unread',
    required: false,
    includeIfNull: false
  )


  final bool? unread;



  @JsonKey(
    defaultValue: false,
    name: r'upvote',
    required: false,
    includeIfNull: false
  )


  final bool? upvote;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadMetaData &&
     other.id == id &&
     other.block == block &&
     other.bookmark == bookmark &&
     other.createdAt == createdAt &&
     other.creator == creator &&
     other.headline == headline &&
     other.lastModified == lastModified &&
     other.numBlocks == numBlocks &&
     other.parentBlockId == parentBlockId &&
     other.title == title &&
     other.type == type &&
     other.unfollow == unfollow &&
     other.unread == unread &&
     other.upvote == upvote;

  @override
  int get hashCode =>
    id.hashCode +
    (block == null ? 0 : block.hashCode) +
    bookmark.hashCode +
    createdAt.hashCode +
    creator.hashCode +
    headline.hashCode +
    lastModified.hashCode +
    numBlocks.hashCode +
    (parentBlockId == null ? 0 : parentBlockId.hashCode) +
    title.hashCode +
    type.hashCode +
    unfollow.hashCode +
    unread.hashCode +
    upvote.hashCode;

  factory ThreadMetaData.fromJson(Map<String, dynamic> json) => _$ThreadMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadMetaDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

