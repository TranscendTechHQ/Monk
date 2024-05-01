//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'update_block_position_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UpdateBlockPositionModel {
  /// Returns a new [UpdateBlockPositionModel] instance.
  UpdateBlockPositionModel({

     this.blockId = '',

     this.newPosition = 0,
  });

  @JsonKey(
    defaultValue: '',
    name: r'block_id',
    required: false,
    includeIfNull: false
  )


  final String? blockId;



  @JsonKey(
    defaultValue: 0,
    name: r'new_position',
    required: false,
    includeIfNull: false
  )


  final int? newPosition;



  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateBlockPositionModel &&
     other.blockId == blockId &&
     other.newPosition == newPosition;

  @override
  int get hashCode =>
    blockId.hashCode +
    newPosition.hashCode;

  factory UpdateBlockPositionModel.fromJson(Map<String, dynamic> json) => _$UpdateBlockPositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBlockPositionModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

