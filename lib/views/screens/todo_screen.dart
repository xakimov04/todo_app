import 'package:dars7/models/todo_model.dart';
import 'package:dars7/viewmodels/todo_viewmodel.dart';
import 'package:dars7/views/widgets/todo_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final todoViewmodel = TodoViewmodel();

  Future<void> addTask() async {
    final data = await showDialog(
      context: context,
      builder: (ctx) => const TodoShowDialog(),
    );

    if (data != null) {
      try {
        todoViewmodel.addTask(
          data['title'],
          data['time'],
          data['isCompleted'],
        );
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error adding task")),
        );
      }
    }
  }

  Future<void> deleteTask(Todo todo) async {
    final response = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 46, 46, 46).withOpacity(.8),
        title: Text(
          "'${todo.title}' ni o'chirmoqchimisz?",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: const Text(
          "Haqiqatan ham bu vazifani oʻchirib tashlamoqchimisiz?",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              "Bekor qilish",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              "O'chirish",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );

    if (response == true) {
      await todoViewmodel.deleteTask(todo.id);
      setState(() {});
    }
  }

  Future<void> editTask(Todo todo) async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return TodoShowDialog(todo: todo);
      },
    );

    if (data != null) {
      todoViewmodel.editTask(
        todo.id,
        data['title'],
        data['time'],
        data['isCompleted'],
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Todo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        backgroundColor: Colors.blueGrey[900],
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoViewmodel.list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No tasks found"),
            );
          }

          final todos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: todos.length,
            itemBuilder: (ctx, index) {
              final item = todos[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          todoViewmodel.editTask(
                            item.id,
                            item.title,
                            item.time,
                            item.isCompleted = !item.isCompleted,
                          );
                        },
                      );
                    },
                    icon: item.isCompleted
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            color: Colors.grey,
                          ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => editTask(item),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blueGrey,
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteTask(item),
                        icon: const Icon(
                          CupertinoIcons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decorationStyle: TextDecorationStyle.wavy,
                      decorationColor: Colors.red,
                      decorationThickness: 5,
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    item.time,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
