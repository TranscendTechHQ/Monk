import 'package:openapi/src/model/block_collection.dart';
import 'package:openapi/src/model/block_model.dart';
import 'package:openapi/src/model/create_thread_model.dart';
import 'package:openapi/src/model/http_validation_error.dart';
import 'package:openapi/src/model/model_date.dart';
import 'package:openapi/src/model/thread_model.dart';
import 'package:openapi/src/model/threads_model.dart';
import 'package:openapi/src/model/update_block_model.dart';
import 'package:openapi/src/model/update_thread_model.dart';
import 'package:openapi/src/model/validation_error.dart';
import 'package:openapi/src/model/validation_error_loc_inner.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'BlockCollection':
          return BlockCollection.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BlockModel':
          return BlockModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateThreadModel':
          return CreateThreadModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HTTPValidationError':
          return HTTPValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ModelDate':
          return ModelDate.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadModel':
          return ThreadModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadType':
          
          
        case 'ThreadsModel':
          return ThreadsModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateBlockModel':
          return UpdateBlockModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateThreadModel':
          return UpdateThreadModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationError':
          return ValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationErrorLocInner':
          return ValidationErrorLocInner.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return Map<dynamic, BaseType>.fromIterables(
              value.keys,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    } 
    throw Exception('Cannot deserialize');
  }