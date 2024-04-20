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

     this.bookmark = false,

     this.read = false,

    required  this.threadId,

     this.unfollow = false,

     this.upvote = false,
  });

  @JsonKey(
    defaultValue: false,
    name: r'bookmark',
    required: false,
    includeIfNull: false
  )


  final bool? bookmark;



  @JsonKey(
    defaultValue: false,
    name: r'read',
    required: false,
    includeIfNull: false
  )


  final bool? read;



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
    name: r'upvote',
    required: false,
    includeIfNull: false
  )


  final bool? upvote;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateUserThreadFlagModel &&
     other.bookmark == bookmark &&
     other.read == read &&
     other.threadId == threadId &&
     other.unfollow == unfollow &&
     other.upvote == upvote;

  @override
  int get hashCode =>
    bookmark.hashCode +
    read.hashCode +
    threadId.hashCode +
    unfollow.hashCode +
    upvote.hashCode;

  factory CreateUserThreadFlagModel.fromJson(Map<String, dynamic> json) => _$CreateUserThreadFlagModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserThreadFlagModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

