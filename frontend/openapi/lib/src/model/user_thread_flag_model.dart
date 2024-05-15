//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_thread_flag_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserThreadFlagModel {
  /// Returns a new [UserThreadFlagModel] instance.
  UserThreadFlagModel({

     this.id,

     this.bookmark = false,

    required  this.tenantId,

    required  this.threadId,

     this.unfollow = false,

     this.unread = false,

     this.upvote = false,

    required  this.userId,
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    defaultValue: false,
    name: r'bookmark',
    required: false,
    includeIfNull: false
  )


  final bool? bookmark;



  @JsonKey(
    
    name: r'tenant_id',
    required: true,
    includeIfNull: false
  )


  final String tenantId;



  @JsonKey(
    
    name: r'thread_id',
    required: true,
    includeIfNull: false
  )


  final String threadId;



  @JsonKey(
    defaultValue: false,
    name: r'unfollow',
    required: false,
    includeIfNull: false
  )


  final bool? unfollow;



  @JsonKey(
    defaultValue: false,
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



  @JsonKey(
    
    name: r'user_id',
    required: true,
    includeIfNull: false
  )


  final String userId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UserThreadFlagModel &&
     other.id == id &&
     other.bookmark == bookmark &&
     other.tenantId == tenantId &&
     other.threadId == threadId &&
     other.unfollow == unfollow &&
     other.unread == unread &&
     other.upvote == upvote &&
     other.userId == userId;

  @override
  int get hashCode =>
    id.hashCode +
    bookmark.hashCode +
    tenantId.hashCode +
    threadId.hashCode +
    unfollow.hashCode +
    unread.hashCode +
    upvote.hashCode +
    userId.hashCode;

  factory UserThreadFlagModel.fromJson(Map<String, dynamic> json) => _$UserThreadFlagModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserThreadFlagModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

