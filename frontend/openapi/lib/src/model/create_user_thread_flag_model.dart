//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_user_thread_flag_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateUserThreadFlagModel {
  /// Returns a new [CreateUserThreadFlagModel] instance.
  CreateUserThreadFlagModel({

     this.bookmark,

    required  this.threadId,

     this.unfollow,

     this.unread,

     this.upvote,
  });

  @JsonKey(
    
    name: r'bookmark',
    required: false,
    includeIfNull: false
  )


  final bool? bookmark;



  @JsonKey(
    
    name: r'thread_id',
    required: true,
    includeIfNull: false
  )


  final String threadId;



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
  bool operator ==(Object other) => identical(this, other) || other is CreateUserThreadFlagModel &&
     other.bookmark == bookmark &&
     other.threadId == threadId &&
     other.unfollow == unfollow &&
     other.unread == unread &&
     other.upvote == upvote;

  @override
  int get hashCode =>
    bookmark.hashCode +
    threadId.hashCode +
    unfollow.hashCode +
    unread.hashCode +
    upvote.hashCode;

  factory CreateUserThreadFlagModel.fromJson(Map<String, dynamic> json) => _$CreateUserThreadFlagModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserThreadFlagModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

