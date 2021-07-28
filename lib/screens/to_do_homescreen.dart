import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/helpers/database_helper.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/screens/add_task_screen.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '${task.title}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                "${_dateFormatter.format(task.date!)} • ${task.priority}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
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
                side: BorderSide(color: Colors.white),
                activeColor: Theme.of(context).primaryColor,
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
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              Icons.add,
              size: 40,
            ),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                        updateTaskList: _updateTaskList,
                      ))),
        ),
        body: Container(
            // color: kPrimaryColor,
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
                padding: EdgeInsets.symmetric(vertical: 40),
                itemCount: 1 + len,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "My Tasks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "$completedTask of ${snapshot.data.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildTask(snapshot.data[index - 1]);
                });
          },
        )));
  }
}
