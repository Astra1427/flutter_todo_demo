import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:todo_demo/study_demo/todo.dart';

class TodoProvider {
  late final Database db;

  Future open(String path) async {
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableTodo(
        $columnId integer primary key autoincrement,
        $columnTitle text not null,
        $columnDone integer not null
        )
        ''');
      },
    );
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo?> query(int id) async {
    var maps = await db.query(
      tableTodo,
      columns: [columnId, columnDone, columnTitle],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Todo.fromMap(maps.first);
  }

  Future<bool> delete(int id) async {
    return await db.delete(
          tableTodo,
          where: '$columnId = ?',
          whereArgs: [id],
        ) > 0;
  }

  Future<bool> update(Todo todo) async {
    return await db.update(
          tableTodo,
          todo.toMap(),
          where: '$columnId = ?',
          whereArgs: [todo.id],
        ) > 0;
  }
}
