// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkMetaModel _$LinkMetaModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'LinkMetaModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['url'],
        );
        final val = LinkMetaModel(
          description: $checkedConvert('description', (v) => v as String?),
          image: $checkedConvert('image', (v) => v as String?),
          title: $checkedConvert('title', (v) => v as String?),
          url: $checkedConvert('url', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$LinkMetaModelToJson(LinkMetaModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('image', instance.image);
  writeNotNull('title', instance.title);
  val['url'] = instance.url;
  return val;
}
