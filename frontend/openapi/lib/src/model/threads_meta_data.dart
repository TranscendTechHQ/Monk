//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/thread_meta_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'threads_meta_data.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ThreadsMetaData {
  /// Returns a new [ThreadsMetaData] instance.
  ThreadsMetaData({

    required  this.metadata,
  });

  @JsonKey(
    
    name: r'metadata',
    required: true,
    includeIfNull: false
  )


  final List<ThreadMetaData> metadata;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ThreadsMetaData &&
     other.metadata == metadata;

  @override
  int get hashCode =>
    metadata.hashCode;

  factory ThreadsMetaData.fromJson(Map<String, dynamic> json) => _$ThreadsMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadsMetaDataToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

