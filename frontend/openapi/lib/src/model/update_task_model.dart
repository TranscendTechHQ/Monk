//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_task_model.g.dart';

/// UpdateTaskModel
///
/// Properties:
/// * [name] 
/// * [goal] 
/// * [completed] 
@BuiltValue()
abstract class UpdateTaskModel implements Built<UpdateTaskModel, UpdateTaskModelBuilder> {
  @BuiltValueField(wireName: r'name')
  JsonObject? get name;

  @BuiltValueField(wireName: r'goal')
  JsonObject? get goal;

  @BuiltValueField(wireName: r'completed')
  JsonObject? get completed;

  UpdateTaskModel._();

  factory UpdateTaskModel([void updates(UpdateTaskModelBuilder b)]) = _$UpdateTaskModel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateTaskModelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateTaskModel> get serializer => _$UpdateTaskModelSerializer();
}

class _$UpdateTaskModelSerializer implements PrimitiveSerializer<UpdateTaskModel> {
  @override
  final Iterable<Type> types = const [UpdateTaskModel, _$UpdateTaskModel];

  @override
  final String wireName = r'UpdateTaskModel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateTaskModel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    if (object.goal != null) {
      yield r'goal';
      yield serializers.serialize(
        object.goal,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    if (object.completed != null) {
      yield r'completed';
      yield serializers.serialize(
        object.completed,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateTaskModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateTaskModelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'goal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.goal = valueDes;
          break;
        case r'completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.completed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateTaskModel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateTaskModelBuilder();
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

