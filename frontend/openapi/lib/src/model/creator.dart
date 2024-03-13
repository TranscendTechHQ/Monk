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

    required  this.email,

    required  this.id,

    required  this.name,

    required  this.picture,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false
  )


  final String email;



  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false
  )


  final String name;



  @JsonKey(
    
    name: r'picture',
    required: true,
    includeIfNull: false
  )


  final String picture;



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

