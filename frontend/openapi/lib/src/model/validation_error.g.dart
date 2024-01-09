// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ValidationError extends ValidationError {
  @override
  final JsonObject? loc;
  @override
  final JsonObject? msg;
  @override
  final JsonObject? type;

  factory _$ValidationError([void Function(ValidationErrorBuilder)? updates]) =>
      (new ValidationErrorBuilder()..update(updates))._build();

  _$ValidationError._({this.loc, this.msg, this.type}) : super._();

  @override
  ValidationError rebuild(void Function(ValidationErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ValidationErrorBuilder toBuilder() =>
      new ValidationErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ValidationError &&
        loc == other.loc &&
        msg == other.msg &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loc.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ValidationError')
          ..add('loc', loc)
          ..add('msg', msg)
          ..add('type', type))
        .toString();
  }
}

class ValidationErrorBuilder
    implements Builder<ValidationError, ValidationErrorBuilder> {
  _$ValidationError? _$v;

  JsonObject? _loc;
  JsonObject? get loc => _$this._loc;
  set loc(JsonObject? loc) => _$this._loc = loc;

  JsonObject? _msg;
  JsonObject? get msg => _$this._msg;
  set msg(JsonObject? msg) => _$this._msg = msg;

  JsonObject? _type;
  JsonObject? get type => _$this._type;
  set type(JsonObject? type) => _$this._type = type;

  ValidationErrorBuilder() {
    ValidationError._defaults(this);
  }

  ValidationErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loc = $v.loc;
      _msg = $v.msg;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ValidationError other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ValidationError;
  }

  @override
  void update(void Function(ValidationErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ValidationError build() => _build();

  _$ValidationError _build() {
    final _$result =
        _$v ?? new _$ValidationError._(loc: loc, msg: msg, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
