// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Creator _$CreatorFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Creator',
      json,
      ($checkedConvert) {
        final val = Creator(
          email:
              $checkedConvert('email', (v) => v as String? ?? 'unknown email'),
          id: $checkedConvert('id', (v) => v as String? ?? 'unknown id'),
          name: $checkedConvert('name', (v) => v as String? ?? 'unknown user'),
          picture: $checkedConvert(
              'picture', (v) => v as String? ?? 'unknown picture link'),
        );
        return val;
      },
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  writeNotNull('id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('picture', instance.picture);
  return val;
}
