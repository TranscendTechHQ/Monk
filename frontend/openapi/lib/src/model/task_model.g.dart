// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TaskModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['name', 'goal', 'completed'],
        );
        final val = TaskModel(
          id: $checkedConvert('_id', (v) => v),
          name: $checkedConvert('name', (v) => v),
          goal: $checkedConvert('goal', (v) => v),
          completed: $checkedConvert('completed', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {'id': '_id'},
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('goal', instance.goal);
  writeNotNull('completed', instance.completed);
  return val;
}
