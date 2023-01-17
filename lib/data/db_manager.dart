import 'package:sqflite/sqflite.dart';
import 'package:todo_demo/models/todo.dart';


import '../models/todo_project.dart';

class DBManager{
  static Database? _db;

  static Future<Database> instance()async{
    return _db ??= await openDatabase("todo.db",version: 1,onCreate: (db,version)async{
      await db.execute(TodoProject.sqlCreate);
      await db.execute(Todo.sqlCreate);
    }) ;
  }

}