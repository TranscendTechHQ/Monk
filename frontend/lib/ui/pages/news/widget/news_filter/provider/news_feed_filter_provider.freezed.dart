// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_feed_filter_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NewsFeedFilterState {
  bool get unRead => throw _privateConstructorUsedError;
  bool get bookmarked => throw _privateConstructorUsedError;
  bool get upvoted => throw _privateConstructorUsedError;
  bool get mentioned => throw _privateConstructorUsedError;
  bool get dismissed => throw _privateConstructorUsedError;
  String? get semanticQuery => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NewsFeedFilterStateCopyWith<NewsFeedFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsFeedFilterStateCopyWith<$Res> {
  factory $NewsFeedFilterStateCopyWith(
          NewsFeedFilterState value, $Res Function(NewsFeedFilterState) then) =
      _$NewsFeedFilterStateCopyWithImpl<$Res, NewsFeedFilterState>;
  @useResult
  $Res call(
      {bool unRead,
      bool bookmarked,
      bool upvoted,
      bool mentioned,
      bool dismissed,
      String? semanticQuery});
}

/// @nodoc
class _$NewsFeedFilterStateCopyWithImpl<$Res, $Val extends NewsFeedFilterState>
    implements $NewsFeedFilterStateCopyWith<$Res> {
  _$NewsFeedFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unRead = null,
    Object? bookmarked = null,
    Object? upvoted = null,
    Object? mentioned = null,
    Object? dismissed = null,
    Object? semanticQuery = freezed,
  }) {
    return _then(_value.copyWith(
      unRead: null == unRead
          ? _value.unRead
          : unRead // ignore: cast_nullable_to_non_nullable
              as bool,
      bookmarked: null == bookmarked
          ? _value.bookmarked
          : bookmarked // ignore: cast_nullable_to_non_nullable
              as bool,
      upvoted: null == upvoted
          ? _value.upvoted
          : upvoted // ignore: cast_nullable_to_non_nullable
              as bool,
      mentioned: null == mentioned
          ? _value.mentioned
          : mentioned // ignore: cast_nullable_to_non_nullable
              as bool,
      dismissed: null == dismissed
          ? _value.dismissed
          : dismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      semanticQuery: freezed == semanticQuery
          ? _value.semanticQuery
          : semanticQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsFeedFilterStateImplCopyWith<$Res>
    implements $NewsFeedFilterStateCopyWith<$Res> {
  factory _$$NewsFeedFilterStateImplCopyWith(_$NewsFeedFilterStateImpl value,
          $Res Function(_$NewsFeedFilterStateImpl) then) =
      __$$NewsFeedFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool unRead,
      bool bookmarked,
      bool upvoted,
      bool mentioned,
      bool dismissed,
      String? semanticQuery});
}

/// @nodoc
class __$$NewsFeedFilterStateImplCopyWithImpl<$Res>
    extends _$NewsFeedFilterStateCopyWithImpl<$Res, _$NewsFeedFilterStateImpl>
    implements _$$NewsFeedFilterStateImplCopyWith<$Res> {
  __$$NewsFeedFilterStateImplCopyWithImpl(_$NewsFeedFilterStateImpl _value,
      $Res Function(_$NewsFeedFilterStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? unRead = null,
    Object? bookmarked = null,
    Object? upvoted = null,
    Object? mentioned = null,
    Object? dismissed = null,
    Object? semanticQuery = freezed,
  }) {
    return _then(_$NewsFeedFilterStateImpl(
      unRead: null == unRead
          ? _value.unRead
          : unRead // ignore: cast_nullable_to_non_nullable
              as bool,
      bookmarked: null == bookmarked
          ? _value.bookmarked
          : bookmarked // ignore: cast_nullable_to_non_nullable
              as bool,
      upvoted: null == upvoted
          ? _value.upvoted
          : upvoted // ignore: cast_nullable_to_non_nullable
              as bool,
      mentioned: null == mentioned
          ? _value.mentioned
          : mentioned // ignore: cast_nullable_to_non_nullable
              as bool,
      dismissed: null == dismissed
          ? _value.dismissed
          : dismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      semanticQuery: freezed == semanticQuery
          ? _value.semanticQuery
          : semanticQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NewsFeedFilterStateImpl implements _NewsFeedFilterState {
  const _$NewsFeedFilterStateImpl(
      {this.unRead = false,
      this.bookmarked = false,
      this.upvoted = false,
      this.mentioned = false,
      this.dismissed = false,
      this.semanticQuery});

  @override
  @JsonKey()
  final bool unRead;
  @override
  @JsonKey()
  final bool bookmarked;
  @override
  @JsonKey()
  final bool upvoted;
  @override
  @JsonKey()
  final bool mentioned;
  @override
  @JsonKey()
  final bool dismissed;
  @override
  final String? semanticQuery;

  @override
  String toString() {
    return 'NewsFeedFilterState(unRead: $unRead, bookmarked: $bookmarked, upvoted: $upvoted, mentioned: $mentioned, dismissed: $dismissed, semanticQuery: $semanticQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsFeedFilterStateImpl &&
            (identical(other.unRead, unRead) || other.unRead == unRead) &&
            (identical(other.bookmarked, bookmarked) ||
                other.bookmarked == bookmarked) &&
            (identical(other.upvoted, upvoted) || other.upvoted == upvoted) &&
            (identical(other.mentioned, mentioned) ||
                other.mentioned == mentioned) &&
            (identical(other.dismissed, dismissed) ||
                other.dismissed == dismissed) &&
            (identical(other.semanticQuery, semanticQuery) ||
                other.semanticQuery == semanticQuery));
  }

  @override
  int get hashCode => Object.hash(runtimeType, unRead, bookmarked, upvoted,
      mentioned, dismissed, semanticQuery);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsFeedFilterStateImplCopyWith<_$NewsFeedFilterStateImpl> get copyWith =>
      __$$NewsFeedFilterStateImplCopyWithImpl<_$NewsFeedFilterStateImpl>(
          this, _$identity);
}

abstract class _NewsFeedFilterState implements NewsFeedFilterState {
  const factory _NewsFeedFilterState(
      {final bool unRead,
      final bool bookmarked,
      final bool upvoted,
      final bool mentioned,
      final bool dismissed,
      final String? semanticQuery}) = _$NewsFeedFilterStateImpl;

  @override
  bool get unRead;
  @override
  bool get bookmarked;
  @override
  bool get upvoted;
  @override
  bool get mentioned;
  @override
  bool get dismissed;
  @override
  String? get semanticQuery;
  @override
  @JsonKey(ignore: true)
  _$$NewsFeedFilterStateImplCopyWith<_$NewsFeedFilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
