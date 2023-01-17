import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_demo/models/todo.dart';
import 'package:todo_demo/pages/todo_edit_page.dart';
import 'package:todo_demo/states/project_state.dart';
import 'package:todo_demo/states/todo_state.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;

  const TodoListItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> subtitle = buildSubtitle(context);

    return ListTile(
      title: Text(
        todo.name,
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: subtitle.isNotEmpty
          ? Row(
              children: subtitle,
            )
          : null,
      trailing: buildTrailing(context),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TodoEditPage(model: todo,)));
      },
    );
  }

  List<Widget> buildSubtitle(BuildContext context) {
    return [
      if (todo.projectId != 0)
        buildBadge(
            Provider.of<ProjectState>(context).findById(todo.projectId)?.name ??
                ""),
      if (todo.deadline > 0)
        buildBadge('截止：${DateTime.fromMillisecondsSinceEpoch(todo.deadline)}')
    ];
  }

  Widget buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(right: 4),
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(2)),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildTrailing(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await Provider.of<TodoState>(context, listen: false).updateTodo(
            Todo.copy(todo)
              ..finished = (todo.finished == Todo.todoFinished
                  ? Todo.todoUnfinished
                  : Todo.todoFinished),
          );
        },
        icon: Icon(
          todo.finished == Todo.todoFinished
              ? Icons.check_box
              : Icons.check_box_outline_blank_outlined,
          color: todo.finished == Todo.todoFinished ? Colors.blue : Colors.grey,
        ));
  }
}
