// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateTaskModel extends UpdateTaskModel {
  @override
  final JsonObject? name;
  @override
  final JsonObject? goal;
  @override
  final JsonObject? completed;

  factory _$UpdateTaskModel([void Function(UpdateTaskModelBuilder)? updates]) =>
      (new UpdateTaskModelBuilder()..update(updates))._build();

  _$UpdateTaskModel._({this.name, this.goal, this.completed}) : super._();

  @override
  UpdateTaskModel rebuild(void Function(UpdateTaskModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateTaskModelBuilder toBuilder() =>
      new UpdateTaskModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateTaskModel &&
        name == other.name &&
        goal == other.goal &&
        completed == other.completed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, goal.hashCode);
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateTaskModel')
          ..add('name', name)
          ..add('goal', goal)
          ..add('completed', completed))
        .toString();
  }
}

class UpdateTaskModelBuilder
    implements Builder<UpdateTaskModel, UpdateTaskModelBuilder> {
  _$UpdateTaskModel? _$v;

  JsonObject? _name;
  JsonObject? get name => _$this._name;
  set name(JsonObject? name) => _$this._name = name;

  JsonObject? _goal;
  JsonObject? get goal => _$this._goal;
  set goal(JsonObject? goal) => _$this._goal = goal;

  JsonObject? _completed;
  JsonObject? get completed => _$this._completed;
  set completed(JsonObject? completed) => _$this._completed = completed;

  UpdateTaskModelBuilder() {
    UpdateTaskModel._defaults(this);
  }

  UpdateTaskModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _goal = $v.goal;
      _completed = $v.completed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateTaskModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateTaskModel;
  }

  @override
  void update(void Function(UpdateTaskModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateTaskModel build() => _build();

  _$UpdateTaskModel _build() {
    final _$result = _$v ??
        new _$UpdateTaskModel._(name: name, goal: goal, completed: completed);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
