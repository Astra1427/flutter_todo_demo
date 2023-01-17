import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_demo/models/todo.dart';
import 'package:todo_demo/models/todo_project.dart';
import 'package:todo_demo/states/project_state.dart';

import '../states/todo_state.dart';

class TodoEditPage extends StatefulWidget {
  final Todo? model;

  const TodoEditPage({Key? key, this.model}) : super(key: key);

  @override
  State<TodoEditPage> createState() => _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  late TextEditingController txtTodoNameController;

  int selectedTodoProjectId = 0;
  String selectedTodoProjectName = "无";
  late final DateTime initialCreateDate;
  late final DateTime initialDeadLineDate;
  DateTime createDate = DateTime.now();
  DateTime? deadLineDate;
  int isFinished = Todo.todoUnfinished;

  @override
  void initState() {
    super.initState();
    txtTodoNameController = TextEditingController(
        text: widget.model != null ? widget.model!.name : "");
    if (widget.model != null) {
      var selectedProject = Provider.of<ProjectState>(context, listen: false)
          .findById(widget.model!.projectId);
      selectedTodoProjectId = selectedProject?.id ?? 0;
      selectedTodoProjectName = selectedProject?.name ?? "无";

      initialCreateDate =
          DateTime.fromMillisecondsSinceEpoch(widget.model!.created);
      initialDeadLineDate = widget.model!.deadline > 0
          ? DateTime.fromMillisecondsSinceEpoch(widget.model!.deadline)
          : DateTime.now();

      createDate = initialCreateDate;
      deadLineDate = initialDeadLineDate;

      isFinished = widget.model!.finished;
    } else {
      initialCreateDate = DateTime.now();
      initialDeadLineDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtTodoNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑代办事项'),
        actions: [
          IconButton(
              onPressed: () {
                onSubmit();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            TextField(
              controller: txtTodoNameController,
              decoration: const InputDecoration(
                  labelText: '名称',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),

            const SizedBox(height: 20),
            buildPickerRow(
                '项目：$selectedTodoProjectName',
                '选择',
                () => showTodoProjectPicker().then((value) {
                      setState(() {
                        if (value == null) return;
                        selectedTodoProjectId = value.id;
                        selectedTodoProjectName = value.name;
                      });
                    })),

            const Divider(thickness: 1, height: 20),
            buildPickerRow('创建时间：$createDate', '更改', showCreateDatePicker),

            const Divider(thickness: 1, height: 20),
            buildPickerRow(
                '截止时间：${deadLineDate ?? '无'}', '更改', showDeadlineDatePicker),

            //finish check row
            Row(
              children: [
                const Text('完成状态'),
                IconButton(
                  onPressed: () {
                    toggleFinished();
                  },
                  icon: Icon(
                    isFinished == Todo.todoFinished
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    size: 36,
                  ),
                  color: isFinished == Todo.todoFinished
                      ? Colors.green
                      : Colors.grey,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildPickerRow(
      String text, String pickButtonText, void Function() pickCallback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
        OutlinedButton(
          onPressed: pickCallback,
          child: Text(pickButtonText),
        )
      ],
    );
  }

  Future<TodoProject?> showTodoProjectPicker() async {
    return await showDialog<TodoProject>(
      context: context,
      builder: (BuildContext dialogContext) {
        var projectList =
            Provider.of<ProjectState>(dialogContext, listen: false).projects;
        return AlertDialog(
          title: const Text('选择项目'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              itemCount: projectList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(projectList[index].name),
                  selected: projectList[index].id == selectedTodoProjectId,
                  selectedColor: Colors.blue,
                  onTap: () {
                    Navigator.of(dialogContext).pop(projectList[index]);
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showCreateDatePicker() async {
    var result = await showDatePicker(
      context: context,
      initialDate: createDate,
      firstDate: initialCreateDate.add(const Duration(days: -365)),
      lastDate: initialCreateDate.add(const Duration(days: 365)),
    );
    if (result == null) return;

    if (deadLineDate != null && result.isAfter(deadLineDate!)) {
      return;
    }
    setState(() {
      createDate = result;
    });
  }

  void showDeadlineDatePicker() async {
    var result = await showDatePicker(
      context: context,
      initialDate: deadLineDate ?? DateTime.now(),
      firstDate: initialDeadLineDate.add(const Duration(days: -365)),
      lastDate: initialDeadLineDate.add(const Duration(days: 365)),
    );
    if (result == null) return;

    if (result.isBefore(createDate)) {
      return;
    }
    setState(() {
      deadLineDate = result;
    });
  }

  void toggleFinished() {
    setState(() {
      isFinished = isFinished != Todo.todoFinished
          ? Todo.todoFinished
          : Todo.todoUnfinished;
    });
  }

  void onSubmit() async {
    if (selectedTodoProjectId == 0) {
      debugPrint('请选择 project');
      return;
    }
    var provider = Provider.of<TodoState>(context, listen: false);

    int newId = provider.todos.last.id + 1;
    var newModel = Todo(
      widget.model == null ? newId : widget.model!.id,
      txtTodoNameController.text,
      selectedTodoProjectId,
      createDate.millisecondsSinceEpoch,
      deadLineDate?.millisecondsSinceEpoch ?? 0,
      isFinished,
    );

    bool result = false;
    if (widget.model == null) {
      result = await provider.createTodo(newModel);
    } else {
      result = await provider.updateTodo(newModel);
    }
    if (!result) {
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('操作失败！'),
            actions: <Widget>[
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop(); // Dismiss alert dialog
  }
}
