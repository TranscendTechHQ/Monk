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

     this.metadata,
  });

  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final Object? content;



  @JsonKey(
    
    name: r'metadata',
    required: false,
    includeIfNull: false
  )


  final Object? metadata;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateBlockModel &&
     other.content == content &&
     other.metadata == metadata;

  @override
  int get hashCode =>
    (content == null ? 0 : content.hashCode) +
    (metadata == null ? 0 : metadata.hashCode);

  factory UpdateBlockModel.fromJson(Map<String, dynamic> json) => _$UpdateBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

