// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockModel extends BlockModel {
  @override
  final JsonObject? id;
  @override
  final JsonObject? content;
  @override
  final JsonObject? metadata;

  factory _$BlockModel([void Function(BlockModelBuilder)? updates]) =>
      (new BlockModelBuilder()..update(updates))._build();

  _$BlockModel._({this.id, this.content, this.metadata}) : super._();

  @override
  BlockModel rebuild(void Function(BlockModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockModelBuilder toBuilder() => new BlockModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockModel &&
        id == other.id &&
        content == other.content &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockModel')
          ..add('id', id)
          ..add('content', content)
          ..add('metadata', metadata))
        .toString();
  }
}

class BlockModelBuilder implements Builder<BlockModel, BlockModelBuilder> {
  _$BlockModel? _$v;

  JsonObject? _id;
  JsonObject? get id => _$this._id;
  set id(JsonObject? id) => _$this._id = id;

  JsonObject? _content;
  JsonObject? get content => _$this._content;
  set content(JsonObject? content) => _$this._content = content;

  JsonObject? _metadata;
  JsonObject? get metadata => _$this._metadata;
  set metadata(JsonObject? metadata) => _$this._metadata = metadata;

  BlockModelBuilder() {
    BlockModel._defaults(this);
  }

  BlockModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _content = $v.content;
      _metadata = $v.metadata;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockModel other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BlockModel;
  }

  @override
  void update(void Function(BlockModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockModel build() => _build();

  _$BlockModel _build() {
    final _$result =
        _$v ?? new _$BlockModel._(id: id, content: content, metadata: metadata);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
