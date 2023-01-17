import 'package:flutter/cupertino.dart';
import 'package:todo_demo/data/todo_manager.dart';

import '../models/todo.dart';

class TodoState with ChangeNotifier {
  List<Todo> todos = [];

  Future<bool> createTodo(Todo model) async {
    bool result = false;
    if (result = await TodoManager.create(model)) {
      todos.add(model);
    }
    notifyListeners();
    return result;
  }

  Future<bool> updateTodo(Todo model) async {
    bool result = false;
    if (result = await TodoManager.update(model)) {
      todos[todos.indexWhere((element) => element.id == model.id)] = model;
    }
    notifyListeners();
    return result;
  }

  Future<void> queryAll() async {
    todos = await TodoManager.queryAll();
    notifyListeners();
  }
}
