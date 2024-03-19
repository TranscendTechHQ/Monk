//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'creator.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Creator {
  /// Returns a new [Creator] instance.
  Creator({

     this.email = 'unknown email',

     this.id = 'unknown id',

     this.name = 'unknown user',

     this.picture = 'unknown picture link',
  });

  @JsonKey(
    defaultValue: 'unknown email',
    name: r'email',
    required: false,
    includeIfNull: false
  )


  final String? email;



  @JsonKey(
    defaultValue: 'unknown id',
    name: r'id',
    required: false,
    includeIfNull: false
  )


  final String? id;



  @JsonKey(
    defaultValue: 'unknown user',
    name: r'name',
    required: false,
    includeIfNull: false
  )


  final String? name;



  @JsonKey(
    defaultValue: 'unknown picture link',
    name: r'picture',
    required: false,
    includeIfNull: false
  )


  final String? picture;



  @override
  bool operator ==(Object other) => identical(this, other) || other is Creator &&
     other.email == email &&
     other.id == id &&
     other.name == name &&
     other.picture == picture;

  @override
  int get hashCode =>
    email.hashCode +
    id.hashCode +
    name.hashCode +
    picture.hashCode;

  factory Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);

  Map<String, dynamic> toJson() => _$CreatorToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

