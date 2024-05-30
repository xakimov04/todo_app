class Todo {
  String id;
  String title;
  String time;
  bool isCompleted = false;

  Todo({
    required this.id,
    required this.time,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'].toString(),
      time: json['time'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'time': time,
    };
  }
}
