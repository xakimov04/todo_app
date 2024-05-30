import 'package:dars7/models/todo_model.dart';
import 'package:flutter/material.dart';

class TodoShowDialog extends StatefulWidget {
  final Todo? todo;

  const TodoShowDialog({super.key, this.todo});

  @override
  State<TodoShowDialog> createState() => _TodoShowDialogState();
}

class _TodoShowDialogState extends State<TodoShowDialog> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _timeController;
  String time = "";

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    time = widget.todo?.time ?? _getCurrentTime();
    _timeController = TextEditingController(text: time);
  }

  String _getCurrentTime() {
    return DateTime.now().toString().substring(11, 16);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        time = picked.format(context);
        _timeController.text = time;
      });
    }
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "title": _titleController.text,
        "time": time,
        "isCompleted": widget.todo?.isCompleted ?? false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 46, 46, 46).withOpacity(.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.todo != null ? "Taskni tahrirlash" : "Task qo'shish",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Task nomi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Iltimos task nomini kiriting";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Vaqtni kiriting",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.access_time,
                          color: Colors.blueAccent,
                        ),
                        onPressed: _selectTime,
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _timeController,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: time,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Bekor qilish",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Saqlash",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
