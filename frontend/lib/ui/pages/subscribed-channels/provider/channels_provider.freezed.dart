// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channels_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChannelsState {
  List<ChannelModel> get publicChannels => throw _privateConstructorUsedError;
  List<ChannelModel> get subscribedChannels =>
      throw _privateConstructorUsedError;
  List<ChannelModel> get selectedChannels => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChannelsStateCopyWith<ChannelsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelsStateCopyWith<$Res> {
  factory $ChannelsStateCopyWith(
          ChannelsState value, $Res Function(ChannelsState) then) =
      _$ChannelsStateCopyWithImpl<$Res, ChannelsState>;
  @useResult
  $Res call(
      {List<ChannelModel> publicChannels,
      List<ChannelModel> subscribedChannels,
      List<ChannelModel> selectedChannels,
      String? message});
}

/// @nodoc
class _$ChannelsStateCopyWithImpl<$Res, $Val extends ChannelsState>
    implements $ChannelsStateCopyWith<$Res> {
  _$ChannelsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicChannels = null,
    Object? subscribedChannels = null,
    Object? selectedChannels = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      publicChannels: null == publicChannels
          ? _value.publicChannels
          : publicChannels // ignore: cast_nullable_to_non_nullable
              as List<ChannelModel>,
      subscribedChannels: null == subscribedChannels
          ? _value.subscribedChannels
          : subscribedChannels // ignore: cast_nullable_to_non_nullable
              as List<ChannelModel>,
      selectedChannels: null == selectedChannels
          ? _value.selectedChannels
          : selectedChannels // ignore: cast_nullable_to_non_nullable
              as List<ChannelModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelsStateImplCopyWith<$Res>
    implements $ChannelsStateCopyWith<$Res> {
  factory _$$ChannelsStateImplCopyWith(
          _$ChannelsStateImpl value, $Res Function(_$ChannelsStateImpl) then) =
      __$$ChannelsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ChannelModel> publicChannels,
      List<ChannelModel> subscribedChannels,
      List<ChannelModel> selectedChannels,
      String? message});
}

/// @nodoc
class __$$ChannelsStateImplCopyWithImpl<$Res>
    extends _$ChannelsStateCopyWithImpl<$Res, _$ChannelsStateImpl>
    implements _$$ChannelsStateImplCopyWith<$Res> {
  __$$ChannelsStateImplCopyWithImpl(
      _$ChannelsStateImpl _value, $Res Function(_$ChannelsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicChannels = null,
    Object? subscribedChannels = null,
    Object? selectedChannels = null,
    Object? message = freezed,
  }) {
    return _then(_$ChannelsStateImpl(
      publicChannels: null == publicChannels
          ? _value._publicChannels
          : publicChannels // ignore: cast_nullable_to_non_nullable
              as List<ChannelModel>,
      subscribedChannels: null == subscribedChannels
          ? _value._subscribedChannels
          : subscribedChannels // ignore: cast_nullable_to_non_nullable
              as List<ChannelModel>,
      selectedChannels: null == selectedChannels
          ? _value._selectedChannels
          : selectedChannels // ignore: cast_nullable_to_non_nullable
              as List<ChannelModel>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChannelsStateImpl implements _ChannelsState {
  const _$ChannelsStateImpl(
      {final List<ChannelModel> publicChannels = const [],
      final List<ChannelModel> subscribedChannels = const [],
      final List<ChannelModel> selectedChannels = const [],
      this.message})
      : _publicChannels = publicChannels,
        _subscribedChannels = subscribedChannels,
        _selectedChannels = selectedChannels;

  final List<ChannelModel> _publicChannels;
  @override
  @JsonKey()
  List<ChannelModel> get publicChannels {
    if (_publicChannels is EqualUnmodifiableListView) return _publicChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_publicChannels);
  }

  final List<ChannelModel> _subscribedChannels;
  @override
  @JsonKey()
  List<ChannelModel> get subscribedChannels {
    if (_subscribedChannels is EqualUnmodifiableListView)
      return _subscribedChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscribedChannels);
  }

  final List<ChannelModel> _selectedChannels;
  @override
  @JsonKey()
  List<ChannelModel> get selectedChannels {
    if (_selectedChannels is EqualUnmodifiableListView)
      return _selectedChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedChannels);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'ChannelsState(publicChannels: $publicChannels, subscribedChannels: $subscribedChannels, selectedChannels: $selectedChannels, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelsStateImpl &&
            const DeepCollectionEquality()
                .equals(other._publicChannels, _publicChannels) &&
            const DeepCollectionEquality()
                .equals(other._subscribedChannels, _subscribedChannels) &&
            const DeepCollectionEquality()
                .equals(other._selectedChannels, _selectedChannels) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_publicChannels),
      const DeepCollectionEquality().hash(_subscribedChannels),
      const DeepCollectionEquality().hash(_selectedChannels),
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelsStateImplCopyWith<_$ChannelsStateImpl> get copyWith =>
      __$$ChannelsStateImplCopyWithImpl<_$ChannelsStateImpl>(this, _$identity);
}

abstract class _ChannelsState implements ChannelsState {
  const factory _ChannelsState(
      {final List<ChannelModel> publicChannels,
      final List<ChannelModel> subscribedChannels,
      final List<ChannelModel> selectedChannels,
      final String? message}) = _$ChannelsStateImpl;

  @override
  List<ChannelModel> get publicChannels;
  @override
  List<ChannelModel> get subscribedChannels;
  @override
  List<ChannelModel> get selectedChannels;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$ChannelsStateImplCopyWith<_$ChannelsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
