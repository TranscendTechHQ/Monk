//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'files_response_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FilesResponseModel {
  /// Returns a new [FilesResponseModel] instance.
  FilesResponseModel({

     this.urls,
  });

  @JsonKey(
    
    name: r'urls',
    required: false,
    includeIfNull: false
  )


  final List<String>? urls;



  @override
  bool operator ==(Object other) => identical(this, other) || other is FilesResponseModel &&
     other.urls == urls;

  @override
  int get hashCode =>
    urls.hashCode;

  factory FilesResponseModel.fromJson(Map<String, dynamic> json) => _$FilesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilesResponseModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

