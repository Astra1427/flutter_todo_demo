
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_demo/models/todo_project.dart';

import '../states/project_state.dart';

class ProjectEditPage extends StatefulWidget {
  final TodoProject? model;

  const ProjectEditPage({Key? key, this.model}) : super(key: key);

  @override
  State<ProjectEditPage> createState() => _ProjectEditPageState();
}

class _ProjectEditPageState extends State<ProjectEditPage> {
  late DateTime selectedCreateDate;
  late DateTime selectedDeadlineDate;

  late final TextEditingController txtProjectNameController;

  @override
  void initState() {
    super.initState();
    txtProjectNameController =
        TextEditingController(text: widget.model?.name ?? "");
    selectedCreateDate = widget.model == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(widget.model!.created);
    selectedDeadlineDate = widget.model == null
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : DateTime.fromMillisecondsSinceEpoch(widget.model!.deadline);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtProjectNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑项目'),
        actions: [
          IconButton(
              onPressed: () {
                onSubmit();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Column(
          children: [
            TextField(
              controller: txtProjectNameController,
              decoration: const InputDecoration(
                prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '名称：',
                      style: TextStyle(fontSize: 16),
                    )),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            Divider(thickness: 1,height: 20,),

            Column(
              children: [
                buildDatePickerRow(
                    context,
                    "创建时间：${selectedCreateDate.toLocal()}",
                    widget.model == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(widget.model!.created), (date) {
                  if (selectedDeadlineDate.millisecondsSinceEpoch != 0 &&
                      date.isAfter(selectedDeadlineDate)) {
                    return false;
                  }
                  setState(() {
                    selectedCreateDate = date;
                  });
                  return true;
                }),
                Divider(thickness: 1,height: 20,),
                buildDatePickerRow(
                    context,
                    "截止时间：${selectedDeadlineDate.millisecondsSinceEpoch == 0 ? "无" : selectedDeadlineDate.toLocal()}",
                    widget.model == null || widget.model!.deadline == 0
                        ? DateTime.now()
                        : DateTime.fromMillisecondsSinceEpoch(widget.model!.deadline), (date) {
                  if (date.isBefore(selectedCreateDate)) {
                    return false;
                  }
                  setState(() {
                    selectedDeadlineDate = date;
                  });
                  return true;
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row buildDatePickerRow(BuildContext context, String dateString,
      DateTime initialDate, bool Function(DateTime) selectedCallback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(dateString),
        buildDatePickerButton(context, initialDate, selectedCallback),
      ],
    );
  }

  ElevatedButton buildDatePickerButton(BuildContext context,
      DateTime initialDate, bool Function(DateTime) selectedCallback) {
    return ElevatedButton(
      onPressed: () async {
        var result = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: initialDate.add(Duration(days: -365)),
            lastDate: initialDate.add(Duration(days: 365)));
        if (result == null) return;
        selectedCallback(result);
      },
      child: Text('更改'),
    );
  }

  void onSubmit() async {
    var projectState = Provider.of<ProjectState>(context,listen: false);
    bool result = false;
    if (widget.model == null) {
      int lastId = projectState.projects.last.id;
      result = await projectState.create(TodoProject(
          lastId + 1,
          txtProjectNameController.text,
          selectedCreateDate.millisecondsSinceEpoch,
          selectedDeadlineDate.millisecondsSinceEpoch));
    } else {
      result = await projectState.update(widget.model!
        ..name = txtProjectNameController.text
        ..created = selectedCreateDate.millisecondsSinceEpoch
        ..deadline = selectedDeadlineDate.millisecondsSinceEpoch);
    }
    if(!result){
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('操作失败'),
            actions: <Widget>[
              TextButton(
                child: Text('确认'),
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
    if(!mounted) return;
    Navigator.of(context).pop();
  }
}
