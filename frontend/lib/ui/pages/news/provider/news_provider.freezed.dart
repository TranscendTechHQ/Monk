// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NewsCardState {
  ThreadMetaData get threadMetaData => throw _privateConstructorUsedError;
  ENewsCardState get estate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NewsCardStateCopyWith<NewsCardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsCardStateCopyWith<$Res> {
  factory $NewsCardStateCopyWith(
          NewsCardState value, $Res Function(NewsCardState) then) =
      _$NewsCardStateCopyWithImpl<$Res, NewsCardState>;
  @useResult
  $Res call({ThreadMetaData threadMetaData, ENewsCardState estate});
}

/// @nodoc
class _$NewsCardStateCopyWithImpl<$Res, $Val extends NewsCardState>
    implements $NewsCardStateCopyWith<$Res> {
  _$NewsCardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadMetaData = null,
    Object? estate = null,
  }) {
    return _then(_value.copyWith(
      threadMetaData: null == threadMetaData
          ? _value.threadMetaData
          : threadMetaData // ignore: cast_nullable_to_non_nullable
              as ThreadMetaData,
      estate: null == estate
          ? _value.estate
          : estate // ignore: cast_nullable_to_non_nullable
              as ENewsCardState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsCardStateImplCopyWith<$Res>
    implements $NewsCardStateCopyWith<$Res> {
  factory _$$NewsCardStateImplCopyWith(
          _$NewsCardStateImpl value, $Res Function(_$NewsCardStateImpl) then) =
      __$$NewsCardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ThreadMetaData threadMetaData, ENewsCardState estate});
}

/// @nodoc
class __$$NewsCardStateImplCopyWithImpl<$Res>
    extends _$NewsCardStateCopyWithImpl<$Res, _$NewsCardStateImpl>
    implements _$$NewsCardStateImplCopyWith<$Res> {
  __$$NewsCardStateImplCopyWithImpl(
      _$NewsCardStateImpl _value, $Res Function(_$NewsCardStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? threadMetaData = null,
    Object? estate = null,
  }) {
    return _then(_$NewsCardStateImpl(
      threadMetaData: null == threadMetaData
          ? _value.threadMetaData
          : threadMetaData // ignore: cast_nullable_to_non_nullable
              as ThreadMetaData,
      estate: null == estate
          ? _value.estate
          : estate // ignore: cast_nullable_to_non_nullable
              as ENewsCardState,
    ));
  }
}

/// @nodoc

class _$NewsCardStateImpl implements _NewsCardState {
  const _$NewsCardStateImpl(
      {required this.threadMetaData, required this.estate});

  @override
  final ThreadMetaData threadMetaData;
  @override
  final ENewsCardState estate;

  @override
  String toString() {
    return 'NewsCardState(threadMetaData: $threadMetaData, estate: $estate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsCardStateImpl &&
            (identical(other.threadMetaData, threadMetaData) ||
                other.threadMetaData == threadMetaData) &&
            (identical(other.estate, estate) || other.estate == estate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, threadMetaData, estate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsCardStateImplCopyWith<_$NewsCardStateImpl> get copyWith =>
      __$$NewsCardStateImplCopyWithImpl<_$NewsCardStateImpl>(this, _$identity);
}

abstract class _NewsCardState implements NewsCardState {
  const factory _NewsCardState(
      {required final ThreadMetaData threadMetaData,
      required final ENewsCardState estate}) = _$NewsCardStateImpl;

  @override
  ThreadMetaData get threadMetaData;
  @override
  ENewsCardState get estate;
  @override
  @JsonKey(ignore: true)
  _$$NewsCardStateImplCopyWith<_$NewsCardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
