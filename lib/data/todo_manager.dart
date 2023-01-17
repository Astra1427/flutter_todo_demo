import 'package:todo_demo/models/todo.dart';

import 'db_manager.dart';

class TodoManager {
  static Future<List<Todo>> queryAll() async {
    var db = await DBManager.instance();
    return (await db.query(Todo.tableName))
        .map((e) => Todo.fromMap(e))
        .toList();
  }

  static Future<bool> create(Todo model) async {
    var db = await DBManager.instance();
    return (await db.insert(Todo.tableName, model.toMap())) > 0;
  }

  static Future<bool> update(Todo model) async {
    var db = await DBManager.instance();
    return (await db.update(Todo.tableName, model.toMap(),
            where: '${Todo.columnId} = ?', whereArgs: [model.id])) > 0;
  }

  
}
