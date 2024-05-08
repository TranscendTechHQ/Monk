// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CurrentTreadState {
  List<BlockWithCreator> get blocks => throw _privateConstructorUsedError;
  FullThreadInfo? get thread => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CurrentTreadStateCopyWith<CurrentTreadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrentTreadStateCopyWith<$Res> {
  factory $CurrentTreadStateCopyWith(
          CurrentTreadState value, $Res Function(CurrentTreadState) then) =
      _$CurrentTreadStateCopyWithImpl<$Res, CurrentTreadState>;
  @useResult
  $Res call({List<BlockWithCreator> blocks, FullThreadInfo? thread});
}

/// @nodoc
class _$CurrentTreadStateCopyWithImpl<$Res, $Val extends CurrentTreadState>
    implements $CurrentTreadStateCopyWith<$Res> {
  _$CurrentTreadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocks = null,
    Object? thread = freezed,
  }) {
    return _then(_value.copyWith(
      blocks: null == blocks
          ? _value.blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<BlockWithCreator>,
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as FullThreadInfo?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrentTreadStateImplCopyWith<$Res>
    implements $CurrentTreadStateCopyWith<$Res> {
  factory _$$CurrentTreadStateImplCopyWith(_$CurrentTreadStateImpl value,
          $Res Function(_$CurrentTreadStateImpl) then) =
      __$$CurrentTreadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BlockWithCreator> blocks, FullThreadInfo? thread});
}

/// @nodoc
class __$$CurrentTreadStateImplCopyWithImpl<$Res>
    extends _$CurrentTreadStateCopyWithImpl<$Res, _$CurrentTreadStateImpl>
    implements _$$CurrentTreadStateImplCopyWith<$Res> {
  __$$CurrentTreadStateImplCopyWithImpl(_$CurrentTreadStateImpl _value,
      $Res Function(_$CurrentTreadStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocks = null,
    Object? thread = freezed,
  }) {
    return _then(_$CurrentTreadStateImpl(
      blocks: null == blocks
          ? _value._blocks
          : blocks // ignore: cast_nullable_to_non_nullable
              as List<BlockWithCreator>,
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as FullThreadInfo?,
    ));
  }
}

/// @nodoc

class _$CurrentTreadStateImpl
    with DiagnosticableTreeMixin
    implements _CurrentTreadState {
  const _$CurrentTreadStateImpl(
      {final List<BlockWithCreator> blocks = const [], this.thread})
      : _blocks = blocks;

  final List<BlockWithCreator> _blocks;
  @override
  @JsonKey()
  List<BlockWithCreator> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  @override
  final FullThreadInfo? thread;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CurrentTreadState(blocks: $blocks, thread: $thread)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CurrentTreadState'))
      ..add(DiagnosticsProperty('blocks', blocks))
      ..add(DiagnosticsProperty('thread', thread));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrentTreadStateImpl &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            (identical(other.thread, thread) || other.thread == thread));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_blocks), thread);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrentTreadStateImplCopyWith<_$CurrentTreadStateImpl> get copyWith =>
      __$$CurrentTreadStateImplCopyWithImpl<_$CurrentTreadStateImpl>(
          this, _$identity);
}

abstract class _CurrentTreadState implements CurrentTreadState {
  const factory _CurrentTreadState(
      {final List<BlockWithCreator> blocks,
      final FullThreadInfo? thread}) = _$CurrentTreadStateImpl;

  @override
  List<BlockWithCreator> get blocks;
  @override
  FullThreadInfo? get thread;
  @override
  @JsonKey(ignore: true)
  _$$CurrentTreadStateImplCopyWith<_$CurrentTreadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
