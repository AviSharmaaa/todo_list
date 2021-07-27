import 'package:flutter/material.dart';

void main() {
  runApp(ToDo());
}

class ToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ToDo List",
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}


class _ToDoListState extends State<ToDoList> {
  List<String> _todoItems = [];

  void _addTodoItem(String task) {
    if(task.length > 0)
    {
      setState(() {
        _todoItems.add(task);
      });
    }
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (BuildContext context, int index) {
        if (index <0) {
          return Container();
        }
        return _buildTodoItem(_todoItems[index], index);
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return ListTile(
        title: Text(todoText),
        onTap: () => _promptRemoveTask(index)
    );
  }

  void _removeTask(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _promptRemoveTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mark "${_todoItems[index]}" as done?'),
          actions: <Widget>[
             TextButton(
              child:  Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
             TextButton(
              child: Text("MARK AS DONE"),
              onPressed: () {
                _removeTask(index);
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Todo List')
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
          onPressed: _pushAddTask,
          tooltip: 'Add task',
          child: Icon(Icons.add)
      ),
    );
  }

  void _pushAddTask() {
    Navigator.of(context).push(
       MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Add anew task"),
              ),
              body: TextField(
                autofocus: true,
                onSubmitted: (val) {
                  _addTodoItem(val);
                  Navigator.pop(context);
                },
                decoration: InputDecoration(
                  hintText: "Enter task",
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            );
          }
      ),
    );
  }
}