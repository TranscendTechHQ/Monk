//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'block_collection.g.dart';

@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BlockCollection {
  /// Returns a new [BlockCollection] instance.
  BlockCollection({
    required this.blocks,
  });

  @JsonKey(name: r'blocks', required: true, includeIfNull: false)
  final Object? blocks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockCollection && other.blocks == blocks;

  @override
  int get hashCode => (blocks == null ? 0 : blocks.hashCode);

  factory BlockCollection.fromJson(Map<String, dynamic> json) =>
      _$BlockCollectionFromJson(json);

  Map<String, dynamic> toJson() => _$BlockCollectionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
