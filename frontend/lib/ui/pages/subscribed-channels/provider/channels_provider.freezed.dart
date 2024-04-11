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
  List<Channel> get publicChannels => throw _privateConstructorUsedError;
  List<Channel> get subscribedChannels => throw _privateConstructorUsedError;
  List<Channel> get selectedChannels => throw _privateConstructorUsedError;
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
      {List<Channel> publicChannels,
      List<Channel> subscribedChannels,
      List<Channel> selectedChannels,
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
              as List<Channel>,
      subscribedChannels: null == subscribedChannels
          ? _value.subscribedChannels
          : subscribedChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
      selectedChannels: null == selectedChannels
          ? _value.selectedChannels
          : selectedChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
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
      {List<Channel> publicChannels,
      List<Channel> subscribedChannels,
      List<Channel> selectedChannels,
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
              as List<Channel>,
      subscribedChannels: null == subscribedChannels
          ? _value._subscribedChannels
          : subscribedChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
      selectedChannels: null == selectedChannels
          ? _value._selectedChannels
          : selectedChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
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
      {final List<Channel> publicChannels = const [],
      final List<Channel> subscribedChannels = const [],
      final List<Channel> selectedChannels = const [],
      this.message})
      : _publicChannels = publicChannels,
        _subscribedChannels = subscribedChannels,
        _selectedChannels = selectedChannels;

  final List<Channel> _publicChannels;
  @override
  @JsonKey()
  List<Channel> get publicChannels {
    if (_publicChannels is EqualUnmodifiableListView) return _publicChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_publicChannels);
  }

  final List<Channel> _subscribedChannels;
  @override
  @JsonKey()
  List<Channel> get subscribedChannels {
    if (_subscribedChannels is EqualUnmodifiableListView)
      return _subscribedChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscribedChannels);
  }

  final List<Channel> _selectedChannels;
  @override
  @JsonKey()
  List<Channel> get selectedChannels {
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
      {final List<Channel> publicChannels,
      final List<Channel> subscribedChannels,
      final List<Channel> selectedChannels,
      final String? message}) = _$ChannelsStateImpl;

  @override
  List<Channel> get publicChannels;
  @override
  List<Channel> get subscribedChannels;
  @override
  List<Channel> get selectedChannels;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$ChannelsStateImplCopyWith<_$ChannelsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return _Channel.fromJson(json);
}

/// @nodoc
mixin _$Channel {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get channelId => throw _privateConstructorUsedError;
  bool get subscribed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChannelCopyWith<Channel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelCopyWith<$Res> {
  factory $ChannelCopyWith(Channel value, $Res Function(Channel) then) =
      _$ChannelCopyWithImpl<$Res, Channel>;
  @useResult
  $Res call({String? id, String? name, String? channelId, bool subscribed});
}

/// @nodoc
class _$ChannelCopyWithImpl<$Res, $Val extends Channel>
    implements $ChannelCopyWith<$Res> {
  _$ChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? channelId = freezed,
    Object? subscribed = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      subscribed: null == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelImplCopyWith<$Res> implements $ChannelCopyWith<$Res> {
  factory _$$ChannelImplCopyWith(
          _$ChannelImpl value, $Res Function(_$ChannelImpl) then) =
      __$$ChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? name, String? channelId, bool subscribed});
}

/// @nodoc
class __$$ChannelImplCopyWithImpl<$Res>
    extends _$ChannelCopyWithImpl<$Res, _$ChannelImpl>
    implements _$$ChannelImplCopyWith<$Res> {
  __$$ChannelImplCopyWithImpl(
      _$ChannelImpl _value, $Res Function(_$ChannelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? channelId = freezed,
    Object? subscribed = null,
  }) {
    return _then(_$ChannelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      channelId: freezed == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String?,
      subscribed: null == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelImpl implements _Channel {
  const _$ChannelImpl(
      {this.id, this.name, this.channelId, this.subscribed = false});

  factory _$ChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? channelId;
  @override
  @JsonKey()
  final bool subscribed;

  @override
  String toString() {
    return 'Channel(id: $id, name: $name, channelId: $channelId, subscribed: $subscribed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.subscribed, subscribed) ||
                other.subscribed == subscribed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, channelId, subscribed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      __$$ChannelImplCopyWithImpl<_$ChannelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelImplToJson(
      this,
    );
  }
}

abstract class _Channel implements Channel {
  const factory _Channel(
      {final String? id,
      final String? name,
      final String? channelId,
      final bool subscribed}) = _$ChannelImpl;

  factory _Channel.fromJson(Map<String, dynamic> json) = _$ChannelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get channelId;
  @override
  bool get subscribed;
  @override
  @JsonKey(ignore: true)
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
