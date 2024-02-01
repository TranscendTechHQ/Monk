//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';


enum ThreadType {
  @JsonValue(r'/new-journal')
  slashNewJournal(r'/new-journal'),
  @JsonValue(r'new-thread')
  newThread(r'new-thread'),
  @JsonValue(r'new-plan')
  newPlan(r'new-plan'),
  @JsonValue(r'news')
  news(r'news'),
  @JsonValue(r'new-report')
  newReport(r'new-report'),
  @JsonValue(r'new-project')
  newProject(r'new-project'),
  @JsonValue(r'new-task')
  newTask(r'new-task'),
  @JsonValue(r'new-note')
  newNote(r'new-note'),
  @JsonValue(r'new-idea')
  newIdea(r'new-idea'),
  @JsonValue(r'new-event')
  newEvent(r'new-event'),
  @JsonValue(r'new-blocker')
  newBlocker(r'new-blocker'),
  @JsonValue(r'new-thought')
  newThought(r'new-thought'),
  @JsonValue(r'new-strategy')
  newStrategy(r'new-strategy'),
  @JsonValue(r'new-private')
  newPrivate(r'new-private'),
  @JsonValue(r'new-experiment')
  newExperiment(r'new-experiment'),
  @JsonValue(r'go')
  go(r'go');

  const ThreadType(this.value);

  final String value;

  @override
  String toString() => value;
}
