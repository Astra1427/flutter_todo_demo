
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_demo/states/todo_state.dart';

import 'pages/home_page.dart';
import 'states/project_state.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ProjectState()),
        ChangeNotifierProvider(create: (_)=>TodoState())
      ],
      child: MaterialApp(

        title: 'todo list',
        home: HomePage(),
      ),
    );
  }
}
