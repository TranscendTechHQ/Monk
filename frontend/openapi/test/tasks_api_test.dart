import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TasksApi
void main() {
  final instance = Openapi().getTasksApi();

  group(TasksApi, () {
    // Create Task
    //
    //Future<TaskModel> createTaskTaskPost(TaskModel taskModel) async
    test('test createTaskTaskPost', () async {
      // TODO
    });

    // Delete Task
    //
    //Future<Object> deleteTaskTaskIdDelete(String id) async
    test('test deleteTaskTaskIdDelete', () async {
      // TODO
    });

    // List Tasks
    //
    //Future<List<TaskModel>> listTasksTaskGet() async
    test('test listTasksTaskGet', () async {
      // TODO
    });

    // Show Task
    //
    //Future<TaskModel> showTaskTaskIdGet(String id) async
    test('test showTaskTaskIdGet', () async {
      // TODO
    });

    // Update Task
    //
    //Future<TaskModel> updateTaskTaskIdPut(String id, UpdateTaskModel updateTaskModel) async
    test('test updateTaskTaskIdPut', () async {
      // TODO
    });

  });
}
