//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'http_validation_error.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HTTPValidationError {
  /// Returns a new [HTTPValidationError] instance.
  HTTPValidationError({

     this.detail,
  });

  @JsonKey(
    
    name: r'detail',
    required: false,
    includeIfNull: false
  )


  final Object? detail;



  @override
  bool operator ==(Object other) => identical(this, other) || other is HTTPValidationError &&
     other.detail == detail;

  @override
  int get hashCode =>
    (detail == null ? 0 : detail.hashCode);

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) => _$HTTPValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$HTTPValidationErrorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

