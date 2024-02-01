//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/thread_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threads_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadsModel {
  /// Returns a new [ThreadsModel] instance.
  ThreadsModel({

    required  this.threads,
  });

  @JsonKey(
    
    name: r'threads',
    required: true,
    includeIfNull: false
  )


  final List<ThreadModel> threads;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadsModel &&
     other.threads == threads;

  @override
  int get hashCode =>
    threads.hashCode;

  factory ThreadsModel.fromJson(Map<String, dynamic> json) => _$ThreadsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadsModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

