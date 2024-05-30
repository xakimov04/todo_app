import 'dart:convert';

import 'package:dars7/models/todo_model.dart';
import 'package:http/http.dart' as http;

class TodoHttpService {
  Future<List<Todo>> getTask() async {
    Uri url = Uri.parse(
        "https://lesson6-919e8-default-rtdb.firebaseio.com/todo.json");
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Todo> loadedProducts = [];
    if (data != null) {
      data.forEach((key, value) {
        value['id'] = key;
        loadedProducts.add(Todo.fromJson(value));
      });
    }
    return loadedProducts;
  }

  Future<Todo> addTask(String title, String time, bool isCompleted) async {
    Uri url = Uri.parse(
        "https://lesson6-919e8-default-rtdb.firebaseio.com/todo.json");
    Map<String, dynamic> todoTask = {
      "title": title,
      "time": time,
      "isCompleted": isCompleted,
    };
    final response = await http.post(
      url,
      body: jsonEncode(todoTask),
    );

    final data = jsonDecode(response.body);
    todoTask['id'] = data['name'];
    Todo newTask = Todo.fromJson(todoTask);
    return newTask;
  }

  Future<void> editTask(
    String id,
    String newTitle,
    String newTime,
    bool newIsCompleted,
  ) async {
    Uri url = Uri.parse(
        "https://lesson6-919e8-default-rtdb.firebaseio.com/todo/$id.json");

    Map<String, dynamic> productData = {
      "title": newTitle,
      "time": newTime,
      "isCompleted": newIsCompleted,
    };
    final response = await http.patch(
      url,
      body: jsonEncode(productData),
    );
  }

  Future<void> deleteTask(String id) async {
    Uri url = Uri.parse(
        "https://lesson6-919e8-default-rtdb.firebaseio.com/todo/$id.json");

    await http.delete(url);
  }
}
