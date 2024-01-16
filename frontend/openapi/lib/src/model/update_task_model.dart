//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'update_task_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateTaskModel {
  /// Returns a new [UpdateTaskModel] instance.
  UpdateTaskModel({

     this.name,

     this.goal,

     this.completed,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false
  )


  final Object? name;



  @JsonKey(
    
    name: r'goal',
    required: false,
    includeIfNull: false
  )


  final Object? goal;



  @JsonKey(
    
    name: r'completed',
    required: false,
    includeIfNull: false
  )


  final Object? completed;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateTaskModel &&
     other.name == name &&
     other.goal == goal &&
     other.completed == completed;

  @override
  int get hashCode =>
    (name == null ? 0 : name.hashCode) +
    (goal == null ? 0 : goal.hashCode) +
    (completed == null ? 0 : completed.hashCode);

  factory UpdateTaskModel.fromJson(Map<String, dynamic> json) => _$UpdateTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTaskModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

