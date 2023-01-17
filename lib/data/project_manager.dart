import 'package:todo_demo/data/db_manager.dart';
import 'package:todo_demo/models/todo.dart';

import '../models/todo_project.dart';

class ProjectManager {
  static Future<bool> create(TodoProject model) async {
    var db = await DBManager.instance();
    return (await db.insert(TodoProject.tableName, model.toMap())) > 0;
  }

  static Future<TodoProject?> queryById(int id) async {
    var db = await DBManager.instance();
    var maps = await db.query(TodoProject.tableName,
        columns: [
          TodoProject.columnId,
          TodoProject.columnName,
          TodoProject.columnCreated,
          TodoProject.columnDeadline,
        ],
        where: '${TodoProject.columnId} = ?',
        whereArgs: [id]);

    if (maps.isEmpty) return null;
    return TodoProject.fromMap(maps.first);
  }

  static Future<bool> update(TodoProject model) async {
    var db = await DBManager.instance();
    return (await db.update(
          TodoProject.tableName,
          model.toMap(),
          where: "${TodoProject.columnId} = ?",
          whereArgs: [model.id],
        )) >
        0;
  }

  static Future<List<TodoProject>> queryAll() async {
    var db = await DBManager.instance();
    return (await db.query(TodoProject.tableName))
        .map((e) => TodoProject.fromMap(e))
        .toList();
  }
}
