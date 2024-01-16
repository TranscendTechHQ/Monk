// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTaskModel _$UpdateTaskModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateTaskModel',
      json,
      ($checkedConvert) {
        final val = UpdateTaskModel(
          name: $checkedConvert('name', (v) => v),
          goal: $checkedConvert('goal', (v) => v),
          completed: $checkedConvert('completed', (v) => v),
        );
        return val;
      },
    );

Map<String, dynamic> _$UpdateTaskModelToJson(UpdateTaskModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('goal', instance.goal);
  writeNotNull('completed', instance.completed);
  return val;
}
