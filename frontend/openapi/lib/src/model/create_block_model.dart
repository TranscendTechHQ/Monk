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

    required  this.content,

    required  this.mainThreadId,
  });

  @JsonKey(
    
    name: r'content',
    required: true,
    includeIfNull: false
  )


  final String content;



  @JsonKey(
    
    name: r'main_thread_id',
    required: true,
    includeIfNull: false
  )


  final String mainThreadId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateBlockModel &&
     other.content == content &&
     other.mainThreadId == mainThreadId;

  @override
  int get hashCode =>
    content.hashCode +
    mainThreadId.hashCode;

  factory CreateBlockModel.fromJson(Map<String, dynamic> json) => _$CreateBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateBlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

