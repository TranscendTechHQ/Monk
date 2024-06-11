// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_filter_preference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFilterPreferenceModel _$UserFilterPreferenceModelFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UserFilterPreferenceModel',
      json,
      ($checkedConvert) {
        final val = UserFilterPreferenceModel(
          bookmark: $checkedConvert('bookmark', (v) => v as bool?),
          mention: $checkedConvert('mention', (v) => v as bool?),
          searchQuery: $checkedConvert('searchQuery', (v) => v as String?),
          unfollow: $checkedConvert('unfollow', (v) => v as bool?),
          unread: $checkedConvert('unread', (v) => v as bool?),
          upvote: $checkedConvert('upvote', (v) => v as bool?),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserFilterPreferenceModelToJson(
    UserFilterPreferenceModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('bookmark', instance.bookmark);
  writeNotNull('mention', instance.mention);
  writeNotNull('searchQuery', instance.searchQuery);
  writeNotNull('unfollow', instance.unfollow);
  writeNotNull('unread', instance.unread);
  writeNotNull('upvote', instance.upvote);
  return val;
}
