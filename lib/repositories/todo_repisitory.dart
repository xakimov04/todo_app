import 'package:dars7/models/todo_model.dart';
import 'package:dars7/services/todo_http_service.dart';

class TodoRepisitory {
  final todoHttpService = TodoHttpService();

  Future<List<Todo>> getTask() async {
    return todoHttpService.getTask();
  }

  Future<Todo> addTask(String title, String time, bool isCompleted) async {
    final newTask = await todoHttpService.addTask(title, time, isCompleted);
    return newTask;
  }

  Future<void> editTask(
      String id, String newTitle, String newTime, bool newIsCompleted) async {
    await todoHttpService.editTask(id, newTitle, newTime, newIsCompleted);
  }

  Future<void> deleteTask(String id) async {
    await todoHttpService.deleteTask(id);
  }
}
