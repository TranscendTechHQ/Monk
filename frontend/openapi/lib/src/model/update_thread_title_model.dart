//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'update_thread_title_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateThreadTitleModel {
  /// Returns a new [UpdateThreadTitleModel] instance.
  UpdateThreadTitleModel({

    required  this.title,
  });

  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false
  )


  final String title;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateThreadTitleModel &&
     other.title == title;

  @override
  int get hashCode =>
    title.hashCode;

  factory UpdateThreadTitleModel.fromJson(Map<String, dynamic> json) => _$UpdateThreadTitleModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateThreadTitleModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

