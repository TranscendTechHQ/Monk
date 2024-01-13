// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_block_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateBlockModel extends UpdateBlockModel {
  @override
  final JsonObject? content;
  @override
  final JsonObject? metadata;

  factory _$UpdateBlockModel(
          [void Function(UpdateBlockModelBuilder)? updates]) =>
      (new UpdateBlockModelBuilder()..update(updates))._build();

  _$UpdateBlockModel._({this.content, this.metadata}) : super._();

  @override
  UpdateBlockModel rebuild(void Function(UpdateBlockModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateBlockModelBuilder toBuilder() =>
      new UpdateBlockModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateBlockModel &&
        content == other.content &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateBlockModel')
          ..add('content', content)
          ..add('metadata', metadata))
        .toString();
  }
}

class UpdateBlockModelBuilder
    implements Builder<UpdateBlockModel, UpdateBlockModelBuilder> {
  _$UpdateBlockModel? _$v;

  JsonObject? _content;
  JsonObject? get content => _$this._content;
  set content(JsonObject? content) => _$this._content = content;

  JsonObject? _metadata;
  JsonObject? get metadata => _$this._metadata;
  set metadata(JsonObject? metadata) => _$this._metadata = metadata;

  UpdateBlockModelBuilder() {
    UpdateBlockModel._defaults(this);
  }

  UpdateBlockModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _content = $v.content;
      _metadata = $v.metadata;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateBlockModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UpdateBlockModel;
  }

  @override
  void update(void Function(UpdateBlockModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateBlockModel build() => _build();

  _$UpdateBlockModel _build() {
    final _$result =
        _$v ?? new _$UpdateBlockModel._(content: content, metadata: metadata);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
