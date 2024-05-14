//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'link_meta_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LinkMetaModel {
  /// Returns a new [LinkMetaModel] instance.
  LinkMetaModel({

     this.description,

     this.image,

     this.title,

    required  this.url,
  });

  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false
  )


  final String? description;



  @JsonKey(
    
    name: r'image',
    required: false,
    includeIfNull: false
  )


  final String? image;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false
  )


  final String? title;



  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false
  )


  final String url;



  @override
  bool operator ==(Object other) => identical(this, other) || other is LinkMetaModel &&
     other.description == description &&
     other.image == image &&
     other.title == title &&
     other.url == url;

  @override
  int get hashCode =>
    (description == null ? 0 : description.hashCode) +
    (image == null ? 0 : image.hashCode) +
    (title == null ? 0 : title.hashCode) +
    url.hashCode;

  factory LinkMetaModel.fromJson(Map<String, dynamic> json) => _$LinkMetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$LinkMetaModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

