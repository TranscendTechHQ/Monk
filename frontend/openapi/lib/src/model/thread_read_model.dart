//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'thread_read_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadReadModel {
  /// Returns a new [ThreadReadModel] instance.
  ThreadReadModel({

    required  this.email,

    required  this.threadId,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false
  )


  final String email;



  @JsonKey(
    
    name: r'thread_id',
    required: true,
    includeIfNull: false
  )


  final String threadId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadReadModel &&
     other.email == email &&
     other.threadId == threadId;

  @override
  int get hashCode =>
    email.hashCode +
    threadId.hashCode;

  factory ThreadReadModel.fromJson(Map<String, dynamic> json) => _$ThreadReadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadReadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

