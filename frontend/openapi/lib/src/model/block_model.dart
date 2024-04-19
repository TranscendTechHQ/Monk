//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
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

     this.childId = '',

    required  this.content,

     this.createdAt,

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
    defaultValue: 'unknown id',
    name: r'creator_id',
    required: false,
    includeIfNull: false
  )


  final String? creatorId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockModel &&
     other.id == id &&
     other.childId == childId &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.creatorId == creatorId;

  @override
  int get hashCode =>
    id.hashCode +
    childId.hashCode +
    content.hashCode +
    createdAt.hashCode +
    creatorId.hashCode;

  factory BlockModel.fromJson(Map<String, dynamic> json) => _$BlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

