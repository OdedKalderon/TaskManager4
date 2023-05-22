import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/friend_connection.dart';
import 'package:flutter_complete_guide/models/todo_item.dart';
import 'package:flutter_complete_guide/models/user_task.dart';
import 'package:flutter_complete_guide/providers/socialprovider.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_complete_guide/providers/todoprovider.dart';
import 'package:flutter_complete_guide/providers/usertaskprovider.dart';
import 'package:flutter_complete_guide/widgets/todoItem.dart';
import 'package:intl/intl.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/main_drawer.dart';

import '../models/userc.dart';
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
  List<UserC> sharedUsers = [];

  final _nameContorller = TextEditingController();
  final _descriptionContorller = TextEditingController();

  String _taskName = '';
  String _taskDescription = '';
  String _taskDateDue = '';
  bool _taskIsUrgent = false;
  List<Todo> _newtodos = [];
  final _todoController = TextEditingController();
  bool _isLoading = false;

  //input: a todo text/title
  //output: creates and add the todo item with that data to a temporary list. (also unfocuses the keyboard onscreen)
  void _addTodo(String todo) {
    setState(() {
      _newtodos.add(Todo(DateTime.now().millisecondsSinceEpoch.toString(), null, todo, false));
      _todoController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  //input: Todo item
  //output: sets the item's stats to done if undone and the opposite
  void _todoDone(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  //input: Todo item
  //output: deletes the todo item from the temporary list
  void _deleteToDoItem(String todoId) {
    setState(() {
      _newtodos.removeWhere((item) => item.todoId == todoId);
    });
  }

  final _descriptionFocusNode = FocusNode();

  //input: none
  //output: takes the data that was filled within the form, checks if its valid
  //        if valid adds the task, todo items, taskusers/shared users connection (provider functions),
  //        and resets the data filled for a new task to be created
  //        (also shows a loading screen while uploading)
  //        if not valid shows an error message
  void _taskFormSubmit() async {
    final bool isValid = _formKey.currentState.validate() && !_newtodos.isEmpty;
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      _taskDateDue = DateFormat.yMMMd().format(_selectedDate);
      String _tskid = await Provider.of<TaskProvider1>(context, listen: false).submitAddTaskForm(
        _taskName.trim(),
        _taskDescription.trim(),
        _taskDateDue,
        _taskIsUrgent,
        context,
        FirebaseAuth.instance.currentUser.uid,
      );

      for (Todo tudu in _newtodos) {
        await Provider.of<TodoProvider>(context, listen: false).addTodoItems(_tskid, tudu.text, tudu.isDone);
      }
      for (UserC user in sharedUsers) {
        await Provider.of<UserTaskProvider>(context, listen: false).addUserTask(_tskid, user.userId);
      }
      ;

      setState(() {
        _newtodos = [];
        _selectedDate = null;
        _taskName = '';
        _taskDescription = '';
        _taskDateDue = '';
        _taskIsUrgent = false;
        _descriptionContorller.clear();
        _nameContorller.clear();
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task Was Successfully Added'),
        duration: Duration(seconds: 5),
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

  //input: none
  //output: presents on screen a calendar in which you can choose a date, then sets the picked date to the task's date due to.
  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      //row above makes it so the up is always up to date
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 320,
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  controller: _nameContorller,
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
                                  onSaved: (nameFieldValue) => setState(() => _taskName = nameFieldValue),
                                  textInputAction: TextInputAction.next,
                                  maxLength: 20,
                                  onFieldSubmitted: ((_) {
                                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                                  }),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: 62,
                                    height: 62,
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        size: 40,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () {
                                        //defined down this file
                                        pickFriends(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: _descriptionContorller,
                            validator: (descriptionValue) {
                              if (descriptionValue == null || descriptionValue.trim().isEmpty) {
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
                            onSaved: (descriptionFieldValue) => setState(() => _taskDescription = descriptionFieldValue),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(_selectedDate == null ? 'No Date Chosen!' : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                              ),
                              TextButton(
                                  onPressed: _presentDatePicker, //defined up this file
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
                                        margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 6, spreadRadius: 0),
                                            ],
                                            borderRadius: BorderRadius.circular(10)),
                                        child: TextField(
                                          controller: _todoController,
                                          decoration: InputDecoration(hintText: 'Add a new todo item', border: InputBorder.none),
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
                                              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text('Please add a text to the to do field before adding one'),
                                                  duration: Duration(seconds: 2),
                                                ))
                                              : setState(() {
                                                  _addTodo(_todoController.text); //defined up this file
                                                });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).accentColor, minimumSize: Size(60, 60), elevation: 6),
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
                                          //a seperate widget in widgets folder
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
                                !_taskIsUrgent ? 'Status: Not Urgent' : 'Status: Urgent',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                        onPressed: _taskFormSubmit, //defined up this file
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
            ),
    );
  }

  //input: the context of the page
  //output: show on the page (with the context that was inputted) a modal bottom sheet with a search bar
  //        and a list of the signed in user's friends, then lets him search and pick friends to share the task being created with them
  Future<dynamic> pickFriends(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          //setting the users that can be shared with (friends only)
          List<FriendConnection> connections = Provider.of<SocialProvider>(context, listen: false).getFriends();
          List<UserC> searchableUsers = [];
          for (FriendConnection connection in connections) {
            searchableUsers.add(Provider.of<AuthProvider>(context, listen: false)
                .getSpecificUser(Provider.of<SocialProvider>(context, listen: false).getSpecificFriend(connection)));
          }
          ;
          List<UserC> displayedList = List.from(searchableUsers);

          //input: a string value
          //output: shows an updated list of friends presented in the bottom sheet according to the value in the search bar
          void updateList(String value) {
            setState(() {
              displayedList = searchableUsers.where((element) => element.username.toLowerCase().contains(value.toLowerCase())).toList();
            });
          }

          ;
          return StatefulBuilder(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  height: 650,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search for a user',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        onChanged: (value) {
                          state(() {
                            updateList(value); //defined up this method
                          });
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            hintText: 'Search for a specific friend',
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: Colors.grey.shade600),
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: displayedList.length == 0
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                    ),
                                    Center(
                                      child: Text(
                                        'No result found',
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: EdgeInsets.all(10),
                                  child: ListView.builder(
                                    itemCount: displayedList.length,
                                    itemBuilder: ((context, index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                              contentPadding: EdgeInsets.all(8),
                                              title: Text(
                                                displayedList[index].username,
                                                style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(displayedList[index].userProfileUrl),
                                              ),
                                              trailing: !sharedUsers.contains(displayedList[index])
                                                  ? IconButton(
                                                      onPressed: () {
                                                        state(() {
                                                          sharedUsers
                                                              .add(displayedList[index]); //adds the chosen user to the temporary list sharedusers
                                                        });
                                                      },
                                                      icon: Icon(Icons.check_box_outline_blank),
                                                      color: Theme.of(context).primaryColor)
                                                  : IconButton(
                                                      icon: Icon(Icons.check_box),
                                                      onPressed: () {
                                                        state(() {
                                                          sharedUsers.remove(
                                                              displayedList[index]); //removes the chosen user to the temporary list sharedusers
                                                        });
                                                      },
                                                      color: Theme.of(context).primaryColor,
                                                    )),
                                          SizedBox(
                                            height: 8,
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                ))
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
