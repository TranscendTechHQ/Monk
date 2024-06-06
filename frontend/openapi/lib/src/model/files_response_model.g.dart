// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesResponseModel _$FilesResponseModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'FilesResponseModel',
      json,
      ($checkedConvert) {
        final val = FilesResponseModel(
          urls: $checkedConvert('urls',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$FilesResponseModelToJson(FilesResponseModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('urls', instance.urls);
  return val;
}
