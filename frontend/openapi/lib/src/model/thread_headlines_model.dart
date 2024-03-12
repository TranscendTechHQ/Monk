//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/thread_headline_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_headlines_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadHeadlinesModel {
  /// Returns a new [ThreadHeadlinesModel] instance.
  ThreadHeadlinesModel({

    required  this.headlines,
  });

  @JsonKey(
    
    name: r'headlines',
    required: true,
    includeIfNull: false
  )


  final List<ThreadHeadlineModel> headlines;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadHeadlinesModel &&
     other.headlines == headlines;

  @override
  int get hashCode =>
    headlines.hashCode;

  factory ThreadHeadlinesModel.fromJson(Map<String, dynamic> json) => _$ThreadHeadlinesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadHeadlinesModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

