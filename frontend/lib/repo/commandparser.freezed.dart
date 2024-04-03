// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commandparser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CustomCommandInputState {
  List<String> get list => throw _privateConstructorUsedError;
  List<String> get filtered => throw _privateConstructorUsedError;
  String? get selected => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CustomCommandInputStateCopyWith<CustomCommandInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomCommandInputStateCopyWith<$Res> {
  factory $CustomCommandInputStateCopyWith(CustomCommandInputState value,
          $Res Function(CustomCommandInputState) then) =
      _$CustomCommandInputStateCopyWithImpl<$Res, CustomCommandInputState>;
  @useResult
  $Res call(
      {List<String> list,
      List<String> filtered,
      String? selected,
      String query});
}

/// @nodoc
class _$CustomCommandInputStateCopyWithImpl<$Res,
        $Val extends CustomCommandInputState>
    implements $CustomCommandInputStateCopyWith<$Res> {
  _$CustomCommandInputStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? filtered = null,
    Object? selected = freezed,
    Object? query = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<String>,
      filtered: null == filtered
          ? _value.filtered
          : filtered // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String?,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomCommandInputStateImplCopyWith<$Res>
    implements $CustomCommandInputStateCopyWith<$Res> {
  factory _$$CustomCommandInputStateImplCopyWith(
          _$CustomCommandInputStateImpl value,
          $Res Function(_$CustomCommandInputStateImpl) then) =
      __$$CustomCommandInputStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> list,
      List<String> filtered,
      String? selected,
      String query});
}

/// @nodoc
class __$$CustomCommandInputStateImplCopyWithImpl<$Res>
    extends _$CustomCommandInputStateCopyWithImpl<$Res,
        _$CustomCommandInputStateImpl>
    implements _$$CustomCommandInputStateImplCopyWith<$Res> {
  __$$CustomCommandInputStateImplCopyWithImpl(
      _$CustomCommandInputStateImpl _value,
      $Res Function(_$CustomCommandInputStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? filtered = null,
    Object? selected = freezed,
    Object? query = null,
  }) {
    return _then(_$CustomCommandInputStateImpl(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<String>,
      filtered: null == filtered
          ? _value._filtered
          : filtered // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as String?,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CustomCommandInputStateImpl implements _CustomCommandInputState {
  const _$CustomCommandInputStateImpl(
      {final List<String> list = const [],
      final List<String> filtered = const [],
      this.selected,
      this.query = ''})
      : _list = list,
        _filtered = filtered;

  final List<String> _list;
  @override
  @JsonKey()
  List<String> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  final List<String> _filtered;
  @override
  @JsonKey()
  List<String> get filtered {
    if (_filtered is EqualUnmodifiableListView) return _filtered;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filtered);
  }

  @override
  final String? selected;
  @override
  @JsonKey()
  final String query;

  @override
  String toString() {
    return 'CustomCommandInputState(list: $list, filtered: $filtered, selected: $selected, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomCommandInputStateImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            const DeepCollectionEquality().equals(other._filtered, _filtered) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_list),
      const DeepCollectionEquality().hash(_filtered),
      selected,
      query);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomCommandInputStateImplCopyWith<_$CustomCommandInputStateImpl>
      get copyWith => __$$CustomCommandInputStateImplCopyWithImpl<
          _$CustomCommandInputStateImpl>(this, _$identity);
}

abstract class _CustomCommandInputState implements CustomCommandInputState {
  const factory _CustomCommandInputState(
      {final List<String> list,
      final List<String> filtered,
      final String? selected,
      final String query}) = _$CustomCommandInputStateImpl;

  @override
  List<String> get list;
  @override
  List<String> get filtered;
  @override
  String? get selected;
  @override
  String get query;
  @override
  @JsonKey(ignore: true)
  _$$CustomCommandInputStateImplCopyWith<_$CustomCommandInputStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
