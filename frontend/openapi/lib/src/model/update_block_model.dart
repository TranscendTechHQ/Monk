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

     this.content,

     this.position,
  });

  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final String? content;



  @JsonKey(
    
    name: r'position',
    required: false,
    includeIfNull: false
  )


  final int? position;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateBlockModel &&
     other.content == content &&
     other.position == position;

  @override
  int get hashCode =>
    content.hashCode +
    position.hashCode;

  factory UpdateBlockModel.fromJson(Map<String, dynamic> json) => _$UpdateBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

