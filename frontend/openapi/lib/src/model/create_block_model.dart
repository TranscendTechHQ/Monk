//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_block_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateBlockModel {
  /// Returns a new [CreateBlockModel] instance.
  CreateBlockModel({

     this.content,

     this.parentThreadId,
  });

  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false
  )


  final String? content;



  @JsonKey(
    
    name: r'parent_thread_id',
    required: false,
    includeIfNull: false
  )


  final String? parentThreadId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateBlockModel &&
     other.content == content &&
     other.parentThreadId == parentThreadId;

  @override
  int get hashCode =>
    content.hashCode +
    (parentThreadId == null ? 0 : parentThreadId.hashCode);

  factory CreateBlockModel.fromJson(Map<String, dynamic> json) => _$CreateBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

