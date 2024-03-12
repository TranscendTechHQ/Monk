//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'thread_headline_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadHeadlineModel {
  /// Returns a new [ThreadHeadlineModel] instance.
  ThreadHeadlineModel({

    required  this.id,

    required  this.headline,

    required  this.title,
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'headline',
    required: true,
    includeIfNull: false
  )


  final String headline;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false
  )


  final String title;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadHeadlineModel &&
     other.id == id &&
     other.headline == headline &&
     other.title == title;

  @override
  int get hashCode =>
    id.hashCode +
    headline.hashCode +
    title.hashCode;

  factory ThreadHeadlineModel.fromJson(Map<String, dynamic> json) => _$ThreadHeadlineModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadHeadlineModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

