// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_card_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThreadCardState {
  BlockWithCreator get block => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  EThreadCardState get eState => throw _privateConstructorUsedError;
  dynamic get hoverEnabled => throw _privateConstructorUsedError;
  ETaskStatus get taskStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ThreadCardStateCopyWith<ThreadCardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThreadCardStateCopyWith<$Res> {
  factory $ThreadCardStateCopyWith(
          ThreadCardState value, $Res Function(ThreadCardState) then) =
      _$ThreadCardStateCopyWithImpl<$Res, ThreadCardState>;
  @useResult
  $Res call(
      {BlockWithCreator block,
      String type,
      EThreadCardState eState,
      dynamic hoverEnabled,
      ETaskStatus taskStatus});
}

/// @nodoc
class _$ThreadCardStateCopyWithImpl<$Res, $Val extends ThreadCardState>
    implements $ThreadCardStateCopyWith<$Res> {
  _$ThreadCardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = null,
    Object? type = null,
    Object? eState = null,
    Object? hoverEnabled = freezed,
    Object? taskStatus = null,
  }) {
    return _then(_value.copyWith(
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as BlockWithCreator,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      eState: null == eState
          ? _value.eState
          : eState // ignore: cast_nullable_to_non_nullable
              as EThreadCardState,
      hoverEnabled: freezed == hoverEnabled
          ? _value.hoverEnabled
          : hoverEnabled // ignore: cast_nullable_to_non_nullable
              as dynamic,
      taskStatus: null == taskStatus
          ? _value.taskStatus
          : taskStatus // ignore: cast_nullable_to_non_nullable
              as ETaskStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThreadCardStateImplCopyWith<$Res>
    implements $ThreadCardStateCopyWith<$Res> {
  factory _$$ThreadCardStateImplCopyWith(_$ThreadCardStateImpl value,
          $Res Function(_$ThreadCardStateImpl) then) =
      __$$ThreadCardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BlockWithCreator block,
      String type,
      EThreadCardState eState,
      dynamic hoverEnabled,
      ETaskStatus taskStatus});
}

/// @nodoc
class __$$ThreadCardStateImplCopyWithImpl<$Res>
    extends _$ThreadCardStateCopyWithImpl<$Res, _$ThreadCardStateImpl>
    implements _$$ThreadCardStateImplCopyWith<$Res> {
  __$$ThreadCardStateImplCopyWithImpl(
      _$ThreadCardStateImpl _value, $Res Function(_$ThreadCardStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? block = null,
    Object? type = null,
    Object? eState = null,
    Object? hoverEnabled = freezed,
    Object? taskStatus = null,
  }) {
    return _then(_$ThreadCardStateImpl(
      block: null == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as BlockWithCreator,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      eState: null == eState
          ? _value.eState
          : eState // ignore: cast_nullable_to_non_nullable
              as EThreadCardState,
      hoverEnabled:
          freezed == hoverEnabled ? _value.hoverEnabled! : hoverEnabled,
      taskStatus: null == taskStatus
          ? _value.taskStatus
          : taskStatus // ignore: cast_nullable_to_non_nullable
              as ETaskStatus,
    ));
  }
}

/// @nodoc

class _$ThreadCardStateImpl implements _ThreadCardState {
  const _$ThreadCardStateImpl(
      {required this.block,
      required this.type,
      this.eState = EThreadCardState.idle,
      this.hoverEnabled = false,
      this.taskStatus = ETaskStatus.todo});

  @override
  final BlockWithCreator block;
  @override
  final String type;
  @override
  @JsonKey()
  final EThreadCardState eState;
  @override
  @JsonKey()
  final dynamic hoverEnabled;
  @override
  @JsonKey()
  final ETaskStatus taskStatus;

  @override
  String toString() {
    return 'ThreadCardState(block: $block, type: $type, eState: $eState, hoverEnabled: $hoverEnabled, taskStatus: $taskStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThreadCardStateImpl &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.eState, eState) || other.eState == eState) &&
            const DeepCollectionEquality()
                .equals(other.hoverEnabled, hoverEnabled) &&
            (identical(other.taskStatus, taskStatus) ||
                other.taskStatus == taskStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, block, type, eState,
      const DeepCollectionEquality().hash(hoverEnabled), taskStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThreadCardStateImplCopyWith<_$ThreadCardStateImpl> get copyWith =>
      __$$ThreadCardStateImplCopyWithImpl<_$ThreadCardStateImpl>(
          this, _$identity);
}

abstract class _ThreadCardState implements ThreadCardState {
  const factory _ThreadCardState(
      {required final BlockWithCreator block,
      required final String type,
      final EThreadCardState eState,
      final dynamic hoverEnabled,
      final ETaskStatus taskStatus}) = _$ThreadCardStateImpl;

  @override
  BlockWithCreator get block;
  @override
  String get type;
  @override
  EThreadCardState get eState;
  @override
  dynamic get hoverEnabled;
  @override
  ETaskStatus get taskStatus;
  @override
  @JsonKey(ignore: true)
  _$$ThreadCardStateImplCopyWith<_$ThreadCardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
