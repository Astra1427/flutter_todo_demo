import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_demo/components/todo_list_item.dart';
import 'package:todo_demo/models/todo_project.dart';
import 'package:todo_demo/pages/project_edit_page.dart';
import 'package:todo_demo/pages/todo_edit_page.dart';
import 'package:todo_demo/states/project_state.dart';
import 'package:todo_demo/states/todo_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<TodoState>(context, listen: false).queryAll();
    Provider.of<ProjectState>(context, listen: false).queryAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TodoEditPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // await todoState.queryAll();
        },
        child: buildTodoList(),
      ),
    );
  }

  Widget buildTodoList() {
    return Consumer2<TodoState, ProjectState>(
        builder: (context, todoState, projectState, child) {
      int filterProjectId = projectState.selectedProjectId;
      var todos = filterProjectId == 0
          ? todoState.todos
          : todoState.todos
              .where((element) => element.projectId == filterProjectId)
              .toList();

      return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          return TodoListItem(
            todo: todos[index],
          );
        },
      );
    });
  }

  Widget buildDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('项目列表', style: TextStyle(fontSize: 24)),
          ),
          Expanded(child: buildProjectList()),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      const ProjectEditPage()));
            },
            child: const Text('创建项目'),
          )
        ],
      ),
    );
  }

  Widget buildProjectList() {
    return Consumer<ProjectState>(builder: (context, projectState, child) {
      var projects = projectState.projects;
      if (projects.isEmpty || projects[0].id != 0) {
        projects.insert(0, TodoProject(0, "所有", 0, 0));
      }
      return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ListTile(
              selected: projectState.selectedProjectId == projects[index].id,
              title: Text(projects[index].name),
              onTap: () {
                projectState.selectedProjectId = projects[index].id;
              },
              onLongPress: () {
                if (index == 0) return;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ProjectEditPage(model: projects[index])));
              },
            );
          });
    });
  }
}
