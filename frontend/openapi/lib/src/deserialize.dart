import 'package:openapi/src/model/block_model.dart';
import 'package:openapi/src/model/block_with_creator.dart';
import 'package:openapi/src/model/channel_model.dart';
import 'package:openapi/src/model/composite_channel_list.dart';
import 'package:openapi/src/model/create_block_model.dart';
import 'package:openapi/src/model/create_child_thread_model.dart';
import 'package:openapi/src/model/create_thread_model.dart';
import 'package:openapi/src/model/create_user_thread_flag_model.dart';
import 'package:openapi/src/model/full_thread_info.dart';
import 'package:openapi/src/model/http_validation_error.dart';
import 'package:openapi/src/model/session_info.dart';
import 'package:openapi/src/model/subscribe_channel_request.dart';
import 'package:openapi/src/model/subscribed_channel_list.dart';
import 'package:openapi/src/model/thread_meta_data.dart';
import 'package:openapi/src/model/thread_model.dart';
import 'package:openapi/src/model/threads_info.dart';
import 'package:openapi/src/model/threads_meta_data.dart';
import 'package:openapi/src/model/threads_model.dart';
import 'package:openapi/src/model/update_block_model.dart';
import 'package:openapi/src/model/update_block_position_model.dart';
import 'package:openapi/src/model/update_thread_title_model.dart';
import 'package:openapi/src/model/user_map.dart';
import 'package:openapi/src/model/user_model.dart';
import 'package:openapi/src/model/user_thread_flag_model.dart';
import 'package:openapi/src/model/validation_error.dart';

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
        case 'BlockModel':
          return BlockModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'BlockWithCreator':
          return BlockWithCreator.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ChannelModel':
          return ChannelModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CompositeChannelList':
          return CompositeChannelList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateBlockModel':
          return CreateBlockModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateChildThreadModel':
          return CreateChildThreadModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateThreadModel':
          return CreateThreadModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'CreateUserThreadFlagModel':
          return CreateUserThreadFlagModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'FullThreadInfo':
          return FullThreadInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'HTTPValidationError':
          return HTTPValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SessionInfo':
          return SessionInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscribeChannelRequest':
          return SubscribeChannelRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SubscribedChannelList':
          return SubscribedChannelList.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadMetaData':
          return ThreadMetaData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadModel':
          return ThreadModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadsInfo':
          return ThreadsInfo.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadsMetaData':
          return ThreadsMetaData.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ThreadsModel':
          return ThreadsModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateBlockModel':
          return UpdateBlockModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateBlockPositionModel':
          return UpdateBlockPositionModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UpdateThreadTitleModel':
          return UpdateThreadTitleModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserMap':
          return UserMap.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserModel':
          return UserModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'UserThreadFlagModel':
          return UserThreadFlagModel.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'ValidationError':
          return ValidationError.fromJson(value as Map<String, dynamic>) as ReturnType;
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