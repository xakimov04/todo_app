import 'package:dars7/models/todo_model.dart';
import 'package:dars7/repositories/todo_repisitory.dart';

class TodoViewmodel {
  final todoRepisitory = TodoRepisitory();

  List<Todo> _list = [
    Todo(
      id: "1",
      time: "12:00",
      title: "uhlash",
      isCompleted: false,
    )
  ];

  Future<List<Todo>> get list async {
    _list = await todoRepisitory.getTask();
    return [..._list];
  }

  void addTask(String title, String time, bool isCompleted) async {
    final newTask = await todoRepisitory.addTask(title, time, isCompleted);
    _list.add(newTask);
  }

  void editTask(
      String id, String newTitle, String newTime, bool newIsCompleted) {
    todoRepisitory.editTask(id, newTitle, newTime, newIsCompleted);
    final index = _list.indexWhere((product) {
      return product.id == id;
    });

    _list[index].title = newTitle;
    _list[index].time = newTime;
    _list[index].isCompleted = newIsCompleted;
  }

  Future<void> deleteTask(String id) async {
    // Todo delete product

    await todoRepisitory.deleteTask(id);
    _list.removeWhere((product) {
      return product.id == id;
    });
  }
}
