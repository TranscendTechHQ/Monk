//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'model_date.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ModelDate {
  /// Returns a new [ModelDate] instance.
  ModelDate({

    required  this.date,
  });

  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false
  )


  final DateTime date;



  @override
  bool operator ==(Object other) => identical(this, other) || other is ModelDate &&
     other.date == date;

  @override
  int get hashCode =>
    date.hashCode;

  factory ModelDate.fromJson(Map<String, dynamic> json) => _$ModelDateFromJson(json);

  Map<String, dynamic> toJson() => _$ModelDateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

