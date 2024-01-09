import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TasksApi
void main() {
  final instance = Openapi().getTasksApi();

  group(TasksApi, () {
    // Create Task
    //
    //Future<JsonObject> createTaskTaskPost(TaskModel taskModel) async
    test('test createTaskTaskPost', () async {
      // TODO
    });

    // Delete Task
    //
    //Future<JsonObject> deleteTaskTaskIdDelete(JsonObject id) async
    test('test deleteTaskTaskIdDelete', () async {
      // TODO
    });

    // List Tasks
    //
    //Future<BuiltList<TaskModel>> listTasksTaskGet() async
    test('test listTasksTaskGet', () async {
      // TODO
    });

    // Show Task
    //
    //Future<JsonObject> showTaskTaskIdGet(JsonObject id) async
    test('test showTaskTaskIdGet', () async {
      // TODO
    });

    // Update Task
    //
    //Future<JsonObject> updateTaskTaskIdPut(JsonObject id, UpdateTaskModel updateTaskModel) async
    test('test updateTaskTaskIdPut', () async {
      // TODO
    });

  });
}
