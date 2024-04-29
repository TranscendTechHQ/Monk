//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'position_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PositionModel {
  /// Returns a new [PositionModel] instance.
  PositionModel({

     this.position = 0,

     this.threadId = '',
  });

  @JsonKey(
    defaultValue: 0,
    name: r'position',
    required: false,
    includeIfNull: false
  )


  final int? position;



  @JsonKey(
    defaultValue: '',
    name: r'thread_id',
    required: false,
    includeIfNull: false
  )


  final String? threadId;



  @override
  bool operator ==(Object other) => identical(this, other) || other is PositionModel &&
     other.position == position &&
     other.threadId == threadId;

  @override
  int get hashCode =>
    position.hashCode +
    threadId.hashCode;

  factory PositionModel.fromJson(Map<String, dynamic> json) => _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

