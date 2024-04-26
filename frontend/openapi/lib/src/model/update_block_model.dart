//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'update_block_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateBlockModel {
  /// Returns a new [UpdateBlockModel] instance.
  UpdateBlockModel({

     this.blockPosInChild,

     this.blockPosInParent,

     this.content,
  });

  @JsonKey(
    
    name: r'block_pos_in_child',
    required: false,
    includeIfNull: false
  )


  final int? blockPosInChild;



  @JsonKey(
    
    name: r'block_pos_in_parent',
    required: false,
    includeIfNull: false
  )


  final int? blockPosInParent;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final String? content;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateBlockModel &&
     other.blockPosInChild == blockPosInChild &&
     other.blockPosInParent == blockPosInParent &&
     other.content == content;

  @override
  int get hashCode =>
    (blockPosInChild == null ? 0 : blockPosInChild.hashCode) +
    (blockPosInParent == null ? 0 : blockPosInParent.hashCode) +
    content.hashCode;

  factory UpdateBlockModel.fromJson(Map<String, dynamic> json) => _$UpdateBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

