//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'title_model.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TitleModel {
  /// Returns a new [TitleModel] instance.
  TitleModel({

    required  this.titles,
  });

  @JsonKey(
    
    name: r'titles',
    required: true,
    includeIfNull: false
  )


  final List<String> titles;



  @override
  bool operator ==(Object other) => identical(this, other) || other is TitleModel &&
     other.titles == titles;

  @override
  int get hashCode =>
    titles.hashCode;

  factory TitleModel.fromJson(Map<String, dynamic> json) => _$TitleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TitleModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

