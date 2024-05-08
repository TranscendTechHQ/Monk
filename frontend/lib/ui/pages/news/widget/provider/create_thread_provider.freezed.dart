// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_thread_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateThreadState {
  FullThreadInfo? get thread => throw _privateConstructorUsedError;
  ECreateThreadState? get eState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreateThreadStateCopyWith<CreateThreadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateThreadStateCopyWith<$Res> {
  factory $CreateThreadStateCopyWith(
          CreateThreadState value, $Res Function(CreateThreadState) then) =
      _$CreateThreadStateCopyWithImpl<$Res, CreateThreadState>;
  @useResult
  $Res call({FullThreadInfo? thread, ECreateThreadState? eState});
}

/// @nodoc
class _$CreateThreadStateCopyWithImpl<$Res, $Val extends CreateThreadState>
    implements $CreateThreadStateCopyWith<$Res> {
  _$CreateThreadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thread = freezed,
    Object? eState = freezed,
  }) {
    return _then(_value.copyWith(
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as FullThreadInfo?,
      eState: freezed == eState
          ? _value.eState
          : eState // ignore: cast_nullable_to_non_nullable
              as ECreateThreadState?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateThreadStateImplCopyWith<$Res>
    implements $CreateThreadStateCopyWith<$Res> {
  factory _$$CreateThreadStateImplCopyWith(_$CreateThreadStateImpl value,
          $Res Function(_$CreateThreadStateImpl) then) =
      __$$CreateThreadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FullThreadInfo? thread, ECreateThreadState? eState});
}

/// @nodoc
class __$$CreateThreadStateImplCopyWithImpl<$Res>
    extends _$CreateThreadStateCopyWithImpl<$Res, _$CreateThreadStateImpl>
    implements _$$CreateThreadStateImplCopyWith<$Res> {
  __$$CreateThreadStateImplCopyWithImpl(_$CreateThreadStateImpl _value,
      $Res Function(_$CreateThreadStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thread = freezed,
    Object? eState = freezed,
  }) {
    return _then(_$CreateThreadStateImpl(
      thread: freezed == thread
          ? _value.thread
          : thread // ignore: cast_nullable_to_non_nullable
              as FullThreadInfo?,
      eState: freezed == eState
          ? _value.eState
          : eState // ignore: cast_nullable_to_non_nullable
              as ECreateThreadState?,
    ));
  }
}

/// @nodoc

class _$CreateThreadStateImpl implements _CreateThreadState {
  const _$CreateThreadStateImpl(
      {this.thread, this.eState = ECreateThreadState.initial});

  @override
  final FullThreadInfo? thread;
  @override
  @JsonKey()
  final ECreateThreadState? eState;

  @override
  String toString() {
    return 'CreateThreadState(thread: $thread, eState: $eState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateThreadStateImpl &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.eState, eState) || other.eState == eState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, thread, eState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateThreadStateImplCopyWith<_$CreateThreadStateImpl> get copyWith =>
      __$$CreateThreadStateImplCopyWithImpl<_$CreateThreadStateImpl>(
          this, _$identity);
}

abstract class _CreateThreadState implements CreateThreadState {
  const factory _CreateThreadState(
      {final FullThreadInfo? thread,
      final ECreateThreadState? eState}) = _$CreateThreadStateImpl;

  @override
  FullThreadInfo? get thread;
  @override
  ECreateThreadState? get eState;
  @override
  @JsonKey(ignore: true)
  _$$CreateThreadStateImplCopyWith<_$CreateThreadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
