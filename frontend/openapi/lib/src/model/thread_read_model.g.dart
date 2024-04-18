// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_read_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadReadModel _$ThreadReadModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ThreadReadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['email', 'thread_id'],
        );
        final val = ThreadReadModel(
          id: $checkedConvert('_id', (v) => v as String?),
          email: $checkedConvert('email', (v) => v as String),
          threadId: $checkedConvert('thread_id', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'id': '_id', 'threadId': 'thread_id'},
    );

Map<String, dynamic> _$ThreadReadModelToJson(ThreadReadModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['email'] = instance.email;
  val['thread_id'] = instance.threadId;
  return val;
}
