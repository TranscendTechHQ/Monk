//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'create_thread_read_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CreateThreadReadModel {
  /// Returns a new [CreateThreadReadModel] instance.
  CreateThreadReadModel({

    required  this.status,

    required  this.threadId,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false
  )


  final bool status;



  @JsonKey(
    
    name: r'thread_id',
    required: true,
    includeIfNull: false
  )


  final String threadId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateThreadReadModel &&
     other.status == status &&
     other.threadId == threadId;

  @override
  int get hashCode =>
    status.hashCode +
    threadId.hashCode;

  factory CreateThreadReadModel.fromJson(Map<String, dynamic> json) => _$CreateThreadReadModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateThreadReadModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

