//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/creator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thread_meta_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadMetaData {
  /// Returns a new [ThreadMetaData] instance.
  ThreadMetaData({

    required  this.id,

    required  this.createdDate,

    required  this.creator,

    required  this.title,

    required  this.type,
  });

  @JsonKey(
    
    name: r'_id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'created_date',
    required: true,
    includeIfNull: false
  )


  final String createdDate;



  @JsonKey(
    
    name: r'creator',
    required: true,
    includeIfNull: false
  )


  final Creator creator;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false
  )


  final String title;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false
  )


  final String type;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadMetaData &&
     other.id == id &&
     other.createdDate == createdDate &&
     other.creator == creator &&
     other.title == title &&
     other.type == type;

  @override
  int get hashCode =>
    id.hashCode +
    createdDate.hashCode +
    creator.hashCode +
    title.hashCode +
    type.hashCode;

  factory ThreadMetaData.fromJson(Map<String, dynamic> json) => _$ThreadMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadMetaDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

