// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_collection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockCollection extends BlockCollection {
  @override
  final JsonObject? blocks;

  factory _$BlockCollection([void Function(BlockCollectionBuilder)? updates]) =>
      (new BlockCollectionBuilder()..update(updates))._build();

  _$BlockCollection._({this.blocks}) : super._();

  @override
  BlockCollection rebuild(void Function(BlockCollectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockCollectionBuilder toBuilder() =>
      new BlockCollectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockCollection && blocks == other.blocks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, blocks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockCollection')
          ..add('blocks', blocks))
        .toString();
  }
}

class BlockCollectionBuilder
    implements Builder<BlockCollection, BlockCollectionBuilder> {
  _$BlockCollection? _$v;

  JsonObject? _blocks;
  JsonObject? get blocks => _$this._blocks;
  set blocks(JsonObject? blocks) => _$this._blocks = blocks;

  BlockCollectionBuilder() {
    BlockCollection._defaults(this);
  }

  BlockCollectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _blocks = $v.blocks;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockCollection other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BlockCollection;
  }

  @override
  void update(void Function(BlockCollectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockCollection build() => _build();

  _$BlockCollection _build() {
    final _$result = _$v ?? new _$BlockCollection._(blocks: blocks);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
