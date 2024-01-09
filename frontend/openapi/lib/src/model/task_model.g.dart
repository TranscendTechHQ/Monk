// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaskModel extends TaskModel {
  @override
  final JsonObject? id;
  @override
  final JsonObject? name;
  @override
  final JsonObject? goal;
  @override
  final JsonObject? completed;

  factory _$TaskModel([void Function(TaskModelBuilder)? updates]) =>
      (new TaskModelBuilder()..update(updates))._build();

  _$TaskModel._({this.id, this.name, this.goal, this.completed}) : super._();

  @override
  TaskModel rebuild(void Function(TaskModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaskModelBuilder toBuilder() => new TaskModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaskModel &&
        id == other.id &&
        name == other.name &&
        goal == other.goal &&
        completed == other.completed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, goal.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaskModel')
          ..add('id', id)
          ..add('name', name)
          ..add('goal', goal)
          ..add('completed', completed))
        .toString();
  }
}

class TaskModelBuilder implements Builder<TaskModel, TaskModelBuilder> {
  _$TaskModel? _$v;

  JsonObject? _id;
  JsonObject? get id => _$this._id;
  set id(JsonObject? id) => _$this._id = id;

  JsonObject? _name;
  JsonObject? get name => _$this._name;
  set name(JsonObject? name) => _$this._name = name;

  JsonObject? _goal;
  JsonObject? get goal => _$this._goal;
  set goal(JsonObject? goal) => _$this._goal = goal;

  JsonObject? _completed;
  JsonObject? get completed => _$this._completed;
  set completed(JsonObject? completed) => _$this._completed = completed;

  TaskModelBuilder() {
    TaskModel._defaults(this);
  }

  TaskModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _goal = $v.goal;
      _completed = $v.completed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaskModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$TaskModel;
  }

  @override
  void update(void Function(TaskModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaskModel build() => _build();

  _$TaskModel _build() {
    final _$result = _$v ??
        new _$TaskModel._(id: id, name: name, goal: goal, completed: completed);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
