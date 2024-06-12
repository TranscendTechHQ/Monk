//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/block_model.dart';
import 'package:openapi/src/model/block_with_creator.dart';
import 'package:openapi/src/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'full_thread_info.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FullThreadInfo {
  /// Returns a new [FullThreadInfo] instance.
  FullThreadInfo({

    required  this.id,

     this.block,

     this.bookmark,

     this.content,

    required  this.createdAt,

    required  this.creator,

     this.defaultBlock,

     this.headline,

     this.lastModified,

     this.mention,

     this.numBlocks = 0,

     this.parentBlockId,

    required  this.topic,

    required  this.type,

     this.unfollow,

     this.unread,

     this.upvote,
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
    
    name: r'bookmark',
    required: false,
    includeIfNull: false
  )


  final bool? bookmark;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final List<BlockWithCreator>? content;



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
    
    name: r'default_block',
    required: false,
    includeIfNull: false
  )


  final BlockWithCreator? defaultBlock;



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
    
    name: r'mention',
    required: false,
    includeIfNull: false
  )


  final bool? mention;



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



  @JsonKey(
    
    name: r'unfollow',
    required: false,
    includeIfNull: false
  )


  final bool? unfollow;



  @JsonKey(
    
    name: r'unread',
    required: false,
    includeIfNull: false
  )


  final bool? unread;



  @JsonKey(
    
    name: r'upvote',
    required: false,
    includeIfNull: false
  )


  final bool? upvote;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FullThreadInfo &&
     other.id == id &&
     other.block == block &&
     other.bookmark == bookmark &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creator == creator &&
     other.defaultBlock == defaultBlock &&
     other.headline == headline &&
     other.lastModified == lastModified &&
     other.mention == mention &&
     other.numBlocks == numBlocks &&
     other.parentBlockId == parentBlockId &&
     other.topic == topic &&
     other.type == type &&
     other.unfollow == unfollow &&
     other.unread == unread &&
     other.upvote == upvote;

  @override
  int get hashCode =>
    id.hashCode +
    (block == null ? 0 : block.hashCode) +
    (bookmark == null ? 0 : bookmark.hashCode) +
    content.hashCode +
    createdAt.hashCode +
    creator.hashCode +
    defaultBlock.hashCode +
    headline.hashCode +
    lastModified.hashCode +
    (mention == null ? 0 : mention.hashCode) +
    numBlocks.hashCode +
    (parentBlockId == null ? 0 : parentBlockId.hashCode) +
    topic.hashCode +
    type.hashCode +
    (unfollow == null ? 0 : unfollow.hashCode) +
    (unread == null ? 0 : unread.hashCode) +
    (upvote == null ? 0 : upvote.hashCode);

  factory FullThreadInfo.fromJson(Map<String, dynamic> json) => _$FullThreadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FullThreadInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

