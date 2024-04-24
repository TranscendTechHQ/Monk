//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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

     this.bookmark = false,

     this.content,

    required  this.createdDate,

    required  this.creator,

     this.headline,

     this.read = false,

    required  this.title,

    required  this.type,

     this.unfollow = false,

     this.upvote = false,
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    defaultValue: false,
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
    
    name: r'created_date',
    required: true,
    includeIfNull: false
  )


  final String createdDate;



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
    defaultValue: false,
    name: r'read',
    required: false,
    includeIfNull: false
  )


  final bool? read;



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
    defaultValue: false,
    name: r'upvote',
    required: false,
    includeIfNull: false
  )


  final bool? upvote;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FullThreadInfo &&
     other.id == id &&
     other.bookmark == bookmark &&
     other.content == content &&
     other.createdDate == createdDate &&
     other.creator == creator &&
     other.headline == headline &&
     other.read == read &&
     other.title == title &&
     other.type == type &&
     other.unfollow == unfollow &&
     other.upvote == upvote;

  @override
  int get hashCode =>
    id.hashCode +
    bookmark.hashCode +
    content.hashCode +
    createdDate.hashCode +
    creator.hashCode +
    headline.hashCode +
    read.hashCode +
    title.hashCode +
    type.hashCode +
    unfollow.hashCode +
    upvote.hashCode;

  factory FullThreadInfo.fromJson(Map<String, dynamic> json) => _$FullThreadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FullThreadInfoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

