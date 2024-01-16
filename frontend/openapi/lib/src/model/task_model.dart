//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TaskModel {
  /// Returns a new [TaskModel] instance.
  TaskModel({
    this.id,
    required this.name,
    required this.goal,
    required this.completed,
  });

  @JsonKey(name: r'_id', required: false, includeIfNull: false)
  final Object? id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final Object? name;

  @JsonKey(name: r'goal', required: true, includeIfNull: false)
  final Object? goal;

  @JsonKey(name: r'completed', required: true, includeIfNull: false)
  final Object? completed;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          other.id == id &&
          other.name == name &&
          other.goal == goal &&
          other.completed == completed;

  @override
  int get hashCode =>
      (id == null ? 0 : id.hashCode) +
      (name == null ? 0 : name.hashCode) +
      (goal == null ? 0 : goal.hashCode) +
      (completed == null ? 0 : completed.hashCode);

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
