// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateThreadModel _$CreateThreadModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateThreadModel',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['type', 'title'],
        );
        final val = CreateThreadModel(
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$ThreadTypeEnumMap, v)),
          title: $checkedConvert('title', (v) => v as String),
          content: $checkedConvert(
              'content',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => BlockModel.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$CreateThreadModelToJson(CreateThreadModel instance) {
  final val = <String, dynamic>{
    'type': _$ThreadTypeEnumMap[instance.type]!,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', instance.content?.map((e) => e.toJson()).toList());
  return val;
}

const _$ThreadTypeEnumMap = {
  ThreadType.slashNewJournal: '/new-journal',
  ThreadType.newThread: 'new-thread',
  ThreadType.newPlan: 'new-plan',
  ThreadType.news: 'news',
  ThreadType.newReport: 'new-report',
  ThreadType.newProject: 'new-project',
  ThreadType.newTask: 'new-task',
  ThreadType.newNote: 'new-note',
  ThreadType.newIdea: 'new-idea',
  ThreadType.newEvent: 'new-event',
  ThreadType.newBlocker: 'new-blocker',
  ThreadType.newThought: 'new-thought',
  ThreadType.newStrategy: 'new-strategy',
  ThreadType.newPrivate: 'new-private',
  ThreadType.newExperiment: 'new-experiment',
  ThreadType.go: 'go',
};
