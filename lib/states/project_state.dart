import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_demo/data/project_manager.dart';

import '../models/todo_project.dart';

class ProjectState with ChangeNotifier {
  List<TodoProject> projects = [];

  String _selectedProjectName = "";

  String get selectedProjectName => _selectedProjectName;
  set selectedProjectName(String value){
    _selectedProjectName = value;
    notifyListeners();
  }

  int _selectedProjectId = 0;
  int get selectedProjectId => _selectedProjectId;
  set selectedProjectId(int value){
    _selectedProjectId = value;
    notifyListeners();
  }


  void selectProject(String projectName){
    _selectedProjectName = projectName;
    notifyListeners();
  }

  Future<bool> create(TodoProject model) async {
    bool result =false;
    if (result = await ProjectManager.create(model)) {
      projects.add(model);
    }
    notifyListeners();
    return result;
  }

  Future<bool> update(TodoProject model) async {
    bool result = false;

    if (result = await ProjectManager.update(model)) {
      projects[projects.indexWhere((element) => element.id == model.id)] =
          model;
    }
    notifyListeners();
    return result;
  }

  Future<void> queryAll() async {
    projects = await ProjectManager.queryAll();
    notifyListeners();
  }

  Future<void> queryById(int id) async {
    projects.clear();
    var model = await ProjectManager.queryById(id);
    if(model != null){
      projects.add(model);
    }
    notifyListeners();
  }

  TodoProject? findById(int id){
    try{
      return projects.singleWhere((element) => element.id == id);
    }
    on StateError{
      return null;
    }
  }
}
