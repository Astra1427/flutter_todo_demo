import 'package:flutter/scheduler.dart';

const String tableTodo = "todo";
const String columnId = "id";
const String columnTitle = "title";
const String columnDone = "done";

class Todo {
  int id;
  String title;
  bool done;

  Todo(this.id, this.title, this.done);



  Map<String, Object> toMap() => {
        columnId: id,
        columnTitle: title,
        columnDone: done ? 1 : 0,
      };

  Todo.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        title = map[columnTitle],
        done = map[columnDone] == 1;
}
