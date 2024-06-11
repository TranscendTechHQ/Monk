//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_filter_preference_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserFilterPreferenceModel {
  /// Returns a new [UserFilterPreferenceModel] instance.
  UserFilterPreferenceModel({

     this.bookmark,

     this.mention,

     this.searchQuery,

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
    
    name: r'mention',
    required: false,
    includeIfNull: false
  )


  final bool? mention;



  @JsonKey(
    
    name: r'searchQuery',
    required: false,
    includeIfNull: false
  )


  final String? searchQuery;



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
  bool operator ==(Object other) => identical(this, other) || other is UserFilterPreferenceModel &&
     other.bookmark == bookmark &&
     other.mention == mention &&
     other.searchQuery == searchQuery &&
     other.unfollow == unfollow &&
     other.unread == unread &&
     other.upvote == upvote;

  @override
  int get hashCode =>
    (bookmark == null ? 0 : bookmark.hashCode) +
    (mention == null ? 0 : mention.hashCode) +
    (searchQuery == null ? 0 : searchQuery.hashCode) +
    (unfollow == null ? 0 : unfollow.hashCode) +
    (unread == null ? 0 : unread.hashCode) +
    (upvote == null ? 0 : upvote.hashCode);

  factory UserFilterPreferenceModel.fromJson(Map<String, dynamic> json) => _$UserFilterPreferenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserFilterPreferenceModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

