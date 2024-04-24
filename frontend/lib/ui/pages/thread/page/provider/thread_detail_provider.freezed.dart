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
  String? get error => throw _privateConstructorUsedError;
  FullThreadInfo? get thread => throw _privateConstructorUsedError;

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
  $Res call({String? error, FullThreadInfo? thread});
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
    Object? error = freezed,
    Object? thread = freezed,
  }) {
    return _then(_value.copyWith(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as FullThreadInfo?,
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
  $Res call({String? error, FullThreadInfo? thread});
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
    Object? error = freezed,
    Object? thread = freezed,
  }) {
    return _then(_$ThreadDetailStateImpl(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as FullThreadInfo?,
    ));
  }
}

/// @nodoc

class _$ThreadDetailStateImpl implements _ThreadDetailState {
  const _$ThreadDetailStateImpl({this.error, required this.thread});

  @override
  final String? error;
  @override
  final FullThreadInfo? thread;

  @override
  String toString() {
    return 'ThreadDetailState(error: $error, thread: $thread)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThreadDetailStateImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.thread, thread) || other.thread == thread));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, thread);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThreadDetailStateImplCopyWith<_$ThreadDetailStateImpl> get copyWith =>
      __$$ThreadDetailStateImplCopyWithImpl<_$ThreadDetailStateImpl>(
          this, _$identity);
}

abstract class _ThreadDetailState implements ThreadDetailState {
  const factory _ThreadDetailState(
      {final String? error,
      required final FullThreadInfo? thread}) = _$ThreadDetailStateImpl;

  @override
  String? get error;
  @override
  FullThreadInfo? get thread;
  @override
  @JsonKey(ignore: true)
  _$$ThreadDetailStateImplCopyWith<_$ThreadDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
