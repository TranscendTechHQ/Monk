//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'task_model.g.dart';

/// TaskModel
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [goal] 
/// * [completed] 
@BuiltValue()
abstract class TaskModel implements Built<TaskModel, TaskModelBuilder> {
  @BuiltValueField(wireName: r'_id')
  JsonObject? get id;

  @BuiltValueField(wireName: r'name')
  JsonObject? get name;

  @BuiltValueField(wireName: r'goal')
  JsonObject? get goal;

  @BuiltValueField(wireName: r'completed')
  JsonObject? get completed;

  TaskModel._();

  factory TaskModel([void updates(TaskModelBuilder b)]) = _$TaskModel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaskModelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaskModel> get serializer => _$TaskModelSerializer();
}

class _$TaskModelSerializer implements PrimitiveSerializer<TaskModel> {
  @override
  final Iterable<Type> types = const [TaskModel, _$TaskModel];

  @override
  final String wireName = r'TaskModel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaskModel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'_id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
    yield r'name';
    yield object.name == null ? null : serializers.serialize(
      object.name,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'goal';
    yield object.goal == null ? null : serializers.serialize(
      object.goal,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'completed';
    yield object.completed == null ? null : serializers.serialize(
      object.completed,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TaskModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaskModelBuilder result,
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
  TaskModel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaskModelBuilder();
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

