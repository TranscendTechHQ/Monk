//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_block_model.g.dart';

/// UpdateBlockModel
///
/// Properties:
/// * [content] 
/// * [metadata] 
@BuiltValue()
abstract class UpdateBlockModel implements Built<UpdateBlockModel, UpdateBlockModelBuilder> {
  @BuiltValueField(wireName: r'content')
  JsonObject? get content;

  @BuiltValueField(wireName: r'metadata')
  JsonObject? get metadata;

  UpdateBlockModel._();

  factory UpdateBlockModel([void updates(UpdateBlockModelBuilder b)]) = _$UpdateBlockModel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateBlockModelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateBlockModel> get serializer => _$UpdateBlockModelSerializer();
}

class _$UpdateBlockModelSerializer implements PrimitiveSerializer<UpdateBlockModel> {
  @override
  final Iterable<Type> types = const [UpdateBlockModel, _$UpdateBlockModel];

  @override
  final String wireName = r'UpdateBlockModel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateBlockModel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.content != null) {
      yield r'content';
      yield serializers.serialize(
        object.content,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
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
    UpdateBlockModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateBlockModelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  UpdateBlockModel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateBlockModelBuilder();
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

