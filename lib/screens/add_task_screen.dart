import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/helpers/database_helper.dart';
import 'package:todo_list/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final Function? updateTaskList;

  const AddTaskScreen({Key? key, this.task, this.updateTaskList})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title = "";
  String? _priority = "";
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat("dd-MM-yyyy");
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _title = widget.task!.title;
      _date = widget.task!.date!;
      _priority = widget.task!.priority;
    }

    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  _handleDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2200),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  _deleteTask() {
    DatabaseHelper.instance.deleteTask(widget.task!.id);
    widget.updateTaskList!();
    Navigator.pop(context);
  }

  _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("$_title, $_date, $_priority");
      Task task = Task(title: _title, date: _date, priority: _priority);
      if (widget.task == null) {
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        task.id = widget.task!.id;
        task.status = widget.task!.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList!();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.95),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                  // color: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.task == null ? "Add Task" : "Update Task",
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle:
                                TextStyle(fontSize: 18, color: kTextColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ))),
                        validator: (input) => (input!).trim().isEmpty
                            ? "A Title is Required"
                            : null,
                        onSaved: (input) => _title = input,
                        initialValue: _title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        showCursor: false,
                        readOnly: true,
                        controller: _dateController,
                        style: TextStyle(fontSize: 18),
                        onTap: _handleDate,
                        decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle:
                                TextStyle(fontSize: 18, color: kTextColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(Icons.arrow_drop_down_sharp),
                        iconSize: 22,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: TextStyle(fontSize: 18, color: kTextColor),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle:
                                TextStyle(fontSize: 18, color: kTextColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (input) =>
                            _priority == null ? "A Priority is Required" : null,
                        onChanged: (value) {
                          setState(() {
                            _priority = value.toString();
                          });
                        },
                        // value: _priority,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: kGradient,
                      ),
                      child: TextButton(
                        child: Text(
                          widget.task == null ? "Add Task" : "Update Task",
                          style: TextStyle(
                            color: kTextColor2,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: _submitTask,
                      ),
                    ),
                    widget.task != null
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 60,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    colors: [Color(0xFFFF0000), Color(0xFF990000).withOpacity(0.74)])),
                            child: TextButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: kTextColor2,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: _deleteTask,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
