//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'validation_error.g.dart';

/// ValidationError
///
/// Properties:
/// * [loc] 
/// * [msg] 
/// * [type] 
@BuiltValue()
abstract class ValidationError implements Built<ValidationError, ValidationErrorBuilder> {
  @BuiltValueField(wireName: r'loc')
  JsonObject? get loc;

  @BuiltValueField(wireName: r'msg')
  JsonObject? get msg;

  @BuiltValueField(wireName: r'type')
  JsonObject? get type;

  ValidationError._();

  factory ValidationError([void updates(ValidationErrorBuilder b)]) = _$ValidationError;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ValidationErrorBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ValidationError> get serializer => _$ValidationErrorSerializer();
}

class _$ValidationErrorSerializer implements PrimitiveSerializer<ValidationError> {
  @override
  final Iterable<Type> types = const [ValidationError, _$ValidationError];

  @override
  final String wireName = r'ValidationError';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ValidationError object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'loc';
    yield object.loc == null ? null : serializers.serialize(
      object.loc,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'msg';
    yield object.msg == null ? null : serializers.serialize(
      object.msg,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'type';
    yield object.type == null ? null : serializers.serialize(
      object.type,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ValidationError object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ValidationErrorBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'loc':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.loc = valueDes;
          break;
        case r'msg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.msg = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ValidationError deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ValidationErrorBuilder();
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

