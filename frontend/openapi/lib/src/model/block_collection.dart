//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'block_collection.g.dart';

/// BlockCollection
///
/// Properties:
/// * [blocks] 
@BuiltValue()
abstract class BlockCollection implements Built<BlockCollection, BlockCollectionBuilder> {
  @BuiltValueField(wireName: r'blocks')
  JsonObject? get blocks;

  BlockCollection._();

  factory BlockCollection([void updates(BlockCollectionBuilder b)]) = _$BlockCollection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockCollectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockCollection> get serializer => _$BlockCollectionSerializer();
}

class _$BlockCollectionSerializer implements PrimitiveSerializer<BlockCollection> {
  @override
  final Iterable<Type> types = const [BlockCollection, _$BlockCollection];

  @override
  final String wireName = r'BlockCollection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockCollection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'blocks';
    yield object.blocks == null ? null : serializers.serialize(
      object.blocks,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockCollection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BlockCollectionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'blocks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.blocks = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BlockCollection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockCollectionBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

