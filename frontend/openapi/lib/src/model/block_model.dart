//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'block_model.g.dart';

/// BlockModel
///
/// Properties:
/// * [id] 
/// * [content] 
/// * [metadata] 
@BuiltValue()
abstract class BlockModel implements Built<BlockModel, BlockModelBuilder> {
  @BuiltValueField(wireName: r'_id')
  JsonObject? get id;

  @BuiltValueField(wireName: r'content')
  JsonObject? get content;

  @BuiltValueField(wireName: r'metadata')
  JsonObject? get metadata;

  BlockModel._();

  factory BlockModel([void updates(BlockModelBuilder b)]) = _$BlockModel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockModelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockModel> get serializer => _$BlockModelSerializer();
}

class _$BlockModelSerializer implements PrimitiveSerializer<BlockModel> {
  @override
  final Iterable<Type> types = const [BlockModel, _$BlockModel];

  @override
  final String wireName = r'BlockModel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockModel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'_id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    yield r'content';
    yield object.content == null ? null : serializers.serialize(
      object.content,
      specifiedType: const FullType.nullable(JsonObject),
    );
    if (object.metadata != null) {
      yield r'metadata';
      yield serializers.serialize(
        object.metadata,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BlockModelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.content = valueDes;
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.metadata = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BlockModel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockModelBuilder();
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

