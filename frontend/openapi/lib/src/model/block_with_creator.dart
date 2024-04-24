//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'block_with_creator.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BlockWithCreator {
  /// Returns a new [BlockWithCreator] instance.
  BlockWithCreator({

     this.id,

     this.childId = '',

    required  this.content,

     this.createdAt,

    required  this.creator,

     this.creatorId = 'unknown id',
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    defaultValue: '',
    name: r'child_id',
    required: false,
    includeIfNull: false
  )


  final String? childId;



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
    
    name: r'creator',
    required: true,
    includeIfNull: false
  )


  final UserModel creator;



  @JsonKey(
    defaultValue: 'unknown id',
    name: r'creator_id',
    required: false,
    includeIfNull: false
  )


  final String? creatorId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockWithCreator &&
     other.id == id &&
     other.childId == childId &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creator == creator &&
     other.creatorId == creatorId;

  @override
  int get hashCode =>
    id.hashCode +
    childId.hashCode +
    content.hashCode +
    createdAt.hashCode +
    creator.hashCode +
    creatorId.hashCode;

  factory BlockWithCreator.fromJson(Map<String, dynamic> json) => _$BlockWithCreatorFromJson(json);

  Map<String, dynamic> toJson() => _$BlockWithCreatorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

