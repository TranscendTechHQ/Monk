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

    required  this.content,

     this.createdAt,

     this.createdBy = 'unknown user',

     this.creatorEmail = 'unknown email',

     this.creatorPicture = 'unknown picture link',
  });

  @JsonKey(
    
    name: r'_id',
    required: false,
    includeIfNull: false
  )


  final String? id;



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
    defaultValue: 'unknown user',
    name: r'created_by',
    required: false,
    includeIfNull: false
  )


  final String? createdBy;



  @JsonKey(
    defaultValue: 'unknown email',
    name: r'creator_email',
    required: false,
    includeIfNull: false
  )


  final String? creatorEmail;



  @JsonKey(
    defaultValue: 'unknown picture link',
    name: r'creator_picture',
    required: false,
    includeIfNull: false
  )


  final String? creatorPicture;



  @override
  bool operator ==(Object other) => identical(this, other) || other is BlockModel &&
     other.id == id &&
     other.content == content &&
     other.createdAt == createdAt &&
     other.createdBy == createdBy &&
     other.creatorEmail == creatorEmail &&
     other.creatorPicture == creatorPicture;

  @override
  int get hashCode =>
    id.hashCode +
    content.hashCode +
    createdAt.hashCode +
    createdBy.hashCode +
    creatorEmail.hashCode +
    creatorPicture.hashCode;

  factory BlockModel.fromJson(Map<String, dynamic> json) => _$BlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

