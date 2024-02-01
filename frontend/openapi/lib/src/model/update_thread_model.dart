//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/block_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_thread_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateThreadModel {
  /// Returns a new [UpdateThreadModel] instance.
  UpdateThreadModel({

    required  this.content,
  });

  @JsonKey(
    
    name: r'content',
    required: true,
    includeIfNull: false
  )


  final List<BlockModel> content;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateThreadModel &&
     other.content == content;

  @override
  int get hashCode =>
    content.hashCode;

  factory UpdateThreadModel.fromJson(Map<String, dynamic> json) => _$UpdateThreadModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateThreadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

