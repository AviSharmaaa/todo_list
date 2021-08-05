import 'package:flutter/material.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/screens/to_do_homescreen.dart';

void main() {
  runApp(ToDo());
}

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0923B0, color),
      ),
      title: "ToDo List",
      home: ToDoScreen(),
    );
  }
}
