import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/helpers/database_helper.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/screens/add_task_screen.dart';
import 'package:todo_list/screens/components/custom_shape.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat("dd-MM-yyyy");

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  Widget _buildTask(Task task) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: kTileColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFC6C6C1).withOpacity(0.8),
                    blurRadius: 5,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  '${task.title}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: kTextColor,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Text(
                  "${_dateFormatter.format(task.date!)} • ${task.priority}",
                  style: TextStyle(
                    fontSize: 15,
                    color: kTextColor,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                trailing: Checkbox(
                  onChanged: (value) {
                    task.status = value! ? 1 : 0;
                    DatabaseHelper.instance.updateTask(task);
                    _updateTaskList();
                  },
                  side: BorderSide(color: kPrimaryColor),
                  activeColor: kPrimaryColor,
                  value: task.status == 1 ? true : false,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddTaskScreen(
                            updateTaskList: _updateTaskList,
                            task: task,
                          )),
                ),
              ),
            ),
            Divider(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.95),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddTaskScreen(
                      updateTaskList: _updateTaskList,
                    ))),
      ),
      body: Container(
          child: FutureBuilder(
        future: _taskList,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final int len = snapshot.data!.length;
          final int completedTask = snapshot.data!
              .where((Task task) => task.status == 1)
              .toList()
              .length;
          return ListView.builder(
              itemCount: 1 + len,
              itemBuilder: (BuildContext context, int index) {
                if (len == 0) {
                  return Container(
                      child: SvgPicture.asset('assets/images/ToDoList.svg'));
                }
                if (index == 0) {
                  return customHeader(
                      context, completedTask, snapshot.data!.length);
                }
                return _buildTask(snapshot.data[index - 1]);
              });
        },
      )),
    );
  }
}
