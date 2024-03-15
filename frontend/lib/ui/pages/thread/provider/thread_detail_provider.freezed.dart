// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_detail_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThreadDetailState {
  BlockModel? get block => throw _privateConstructorUsedError;
  List<BlockModel> get replies => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ThreadDetailStateCopyWith<ThreadDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThreadDetailStateCopyWith<$Res> {
  factory $ThreadDetailStateCopyWith(
          ThreadDetailState value, $Res Function(ThreadDetailState) then) =
      _$ThreadDetailStateCopyWithImpl<$Res, ThreadDetailState>;
  @useResult
  $Res call({BlockModel? block, List<BlockModel> replies});
}

/// @nodoc
class _$ThreadDetailStateCopyWithImpl<$Res, $Val extends ThreadDetailState>
    implements $ThreadDetailStateCopyWith<$Res> {
  _$ThreadDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = freezed,
    Object? replies = null,
  }) {
    return _then(_value.copyWith(
      block: freezed == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as BlockModel?,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<BlockModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThreadDetailStateImplCopyWith<$Res>
    implements $ThreadDetailStateCopyWith<$Res> {
  factory _$$ThreadDetailStateImplCopyWith(_$ThreadDetailStateImpl value,
          $Res Function(_$ThreadDetailStateImpl) then) =
      __$$ThreadDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BlockModel? block, List<BlockModel> replies});
}

/// @nodoc
class __$$ThreadDetailStateImplCopyWithImpl<$Res>
    extends _$ThreadDetailStateCopyWithImpl<$Res, _$ThreadDetailStateImpl>
    implements _$$ThreadDetailStateImplCopyWith<$Res> {
  __$$ThreadDetailStateImplCopyWithImpl(_$ThreadDetailStateImpl _value,
      $Res Function(_$ThreadDetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = freezed,
    Object? replies = null,
  }) {
    return _then(_$ThreadDetailStateImpl(
      block: freezed == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as BlockModel?,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<BlockModel>,
    ));
  }
}

/// @nodoc

class _$ThreadDetailStateImpl implements _ThreadDetailState {
  const _$ThreadDetailStateImpl(
      {required this.block, required final List<BlockModel> replies})
      : _replies = replies;

  @override
  final BlockModel? block;
  final List<BlockModel> _replies;
  @override
  List<BlockModel> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  String toString() {
    return 'ThreadDetailState(block: $block, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThreadDetailStateImpl &&
            (identical(other.block, block) || other.block == block) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, block, const DeepCollectionEquality().hash(_replies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThreadDetailStateImplCopyWith<_$ThreadDetailStateImpl> get copyWith =>
      __$$ThreadDetailStateImplCopyWithImpl<_$ThreadDetailStateImpl>(
          this, _$identity);
}

abstract class _ThreadDetailState implements ThreadDetailState {
  const factory _ThreadDetailState(
      {required final BlockModel? block,
      required final List<BlockModel> replies}) = _$ThreadDetailStateImpl;

  @override
  BlockModel? get block;
  @override
  List<BlockModel> get replies;
  @override
  @JsonKey(ignore: true)
  _$$ThreadDetailStateImplCopyWith<_$ThreadDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
