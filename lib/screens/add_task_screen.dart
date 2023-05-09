import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/todo_item.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_complete_guide/widgets/todoItem.dart';
import 'package:intl/intl.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/main_drawer.dart';

import '../providers/authprovider.dart';
import '../providers/taskprovider.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  String _taskDescription = '';
  String _taskDateDue = '';
  bool _taskIsUrgent = false;

  List<Todo> _newtodos = [];
  final _todoController = TextEditingController();
  void _addTodo(String todo) {
    _newtodos.add(Todo(null, null, todo,
        false)); //need to check how to put the task id ijust created in the field needed
    _todoController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _todoDone(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String todoText) {
    setState(() {
      _newtodos.removeWhere((item) => item.text == todoText);
    });
  }

  final _descriptionFocusNode = FocusNode();

  void _taskFormSubmit() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      _taskDateDue = DateFormat.yMMMd().format(_selectedDate);
      String _tskid = await Provider.of<TaskProvider1>(context, listen: false)
          .submitAddTaskForm(
        _taskName.trim(),
        _taskDescription.trim(),
        _taskDateDue,
        _taskIsUrgent,
        context,
        FirebaseAuth.instance.currentUser.uid,
      );
      //add todo's to firebase while taskId = _tskid
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task Was Successfully Added'),
        duration: Duration(seconds: 3),
      ));
    } else
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could\'nt finish submiting')),
        );
        Navigator.of(context).pop();
        return null;
      };
  }

  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      //row above (41) makes it so the up is always up to date
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _taskDateDue = _selectedDate.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Add Task', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TextFormField(
                    validator: (nameValue) {
                      if (nameValue == null || nameValue.trim().isEmpty) {
                        return 'Please enter a name';
                      } else if (nameValue.length > 20) {
                        return 'Name can be up to 20 characters long';
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Add Task Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (nameFieldValue) =>
                        setState(() => _taskName = nameFieldValue),
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    onFieldSubmitted: ((_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (descriptionValue) {
                      if (descriptionValue == null ||
                          descriptionValue.trim().isEmpty) {
                        return 'Please enter a Description';
                      } else if (descriptionValue.length > 80) {
                        return 'Description can be up to 80 characters long';
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Add Task Description',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 80,
                    focusNode: _descriptionFocusNode,
                    onSaved: (descriptionFieldValue) => setState(
                        () => _taskDescription = descriptionFieldValue),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                      ),
                      TextButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Things To Do',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: 20, right: 20, left: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 0),
                                          blurRadius: 6,
                                          spreadRadius: 0),
                                    ],
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  controller: _todoController,
                                  decoration: InputDecoration(
                                      hintText: 'Add a new todo item',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20, right: 20),
                              child: ElevatedButton(
                                child: Text(
                                  '+',
                                  style: TextStyle(fontSize: 40),
                                ),
                                onPressed: () {
                                  _todoController.text.isEmpty
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              'Please add a text to the to do field before adding one'),
                                          duration: Duration(seconds: 2),
                                        ))
                                      : setState(() {
                                          _addTodo(_todoController.text);
                                        });
                                  ;
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    minimumSize: Size(60, 60),
                                    elevation: 6),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          height: 240,
                          child: ListView(
                            children: [
                              for (Todo todoo in _newtodos)
                                TodoItem(
                                  todo: todoo,
                                  isDone: _todoDone,
                                  onDeleteItem: _deleteToDoItem,
                                )
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        !_taskIsUrgent
                            ? 'Status: Not Urgent'
                            : 'Status: Urgent',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Switch(
                          value: _taskIsUrgent,
                          activeColor: Colors.red,
                          onChanged: (bool value) {
                            setState(() {
                              _taskIsUrgent = value;
                            });
                          })
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
                onPressed: _taskFormSubmit,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(90, 30),
                  backgroundColor: Theme.of(context).accentColor,
                )),
          ],
        ),
      ),
    );
  }
}
