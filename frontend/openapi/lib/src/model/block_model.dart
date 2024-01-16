//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'block_model.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BlockModel {
  /// Returns a new [BlockModel] instance.
  BlockModel({
    this.id,
    required this.content,
    this.metadata,
  });

  @JsonKey(name: r'_id', required: false, includeIfNull: false)
  final Object? id;

  @JsonKey(name: r'content', required: true, includeIfNull: false)
  final Object? content;

  @JsonKey(name: r'metadata', required: false, includeIfNull: false)
  final Object? metadata;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockModel &&
          other.id == id &&
          other.content == content &&
          other.metadata == metadata;

  @override
  int get hashCode =>
      (id == null ? 0 : id.hashCode) +
      (content == null ? 0 : content.hashCode) +
      (metadata == null ? 0 : metadata.hashCode);

  factory BlockModel.fromJson(Map<String, dynamic> json) =>
      _$BlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlockModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
