// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Creator _$CreatorFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Creator',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['email', 'id', 'name', 'picture'],
        );
        final val = Creator(
          email: $checkedConvert('email', (v) => v as String),
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          picture: $checkedConvert('picture', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$CreatorToJson(Creator instance) => <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
    };
