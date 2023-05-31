import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/user_task.dart';
import 'package:flutter_complete_guide/providers/authprovider.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_complete_guide/providers/todoprovider.dart';
import 'package:flutter_complete_guide/providers/usertaskprovider.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/date_format.dart';

import '../models/task.dart';
import '../models/todo_item.dart';
import '../models/userc.dart';
import '../widgets/todoItem.dart';

class DisplayTaskScreen extends StatefulWidget {
  final Task task;
  List<Todo> taskTodos;
  List<userTask> sharedUsers;
  DisplayTaskScreen({Key key, @required this.task, @required this.taskTodos, @required this.sharedUsers}) : super(key: key);
  @override
  State<DisplayTaskScreen> createState() => _DisplayTaskScreenState();
}

class _DisplayTaskScreenState extends State<DisplayTaskScreen> {
  final _todoController = TextEditingController();

  void _todoDone(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String todoId) {
    setState(() {
      widget.taskTodos.removeWhere((item) => item.todoId == todoId);
    });
  }

  void _addTodo(String todo) {
    setState(() {
      widget.taskTodos.add(Todo(DateTime.now().millisecondsSinceEpoch.toString(), widget.task.TaskId, todo, false));
    });
    _todoController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    List<UserC> getIncluded() {
      List<UserC> included = [];
      String managerId = Provider.of<TaskProvider1>(context, listen: false).getTaskManagerId(widget.task.TaskId);
      included.add(Provider.of<AuthProvider>(context, listen: false).getSpecificUser(managerId));
      for (userTask usertask in widget.sharedUsers) {
        included.add(Provider.of<AuthProvider>(context, listen: false).getSpecificUser(usertask.userId));
      }
      return included;
    }

    final List<Todo> _existing = Provider.of<TodoProvider>(context, listen: false).getTaskTodos(widget.task.TaskId);
    final List<UserC> _included = getIncluded();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage('lib/images/logo.jpg'))),
          ),
          SizedBox(width: 10),
          Text('Task Details', style: GoogleFonts.quicksand(fontWeight: FontWeight.w400)),
        ]),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Container(
              height: 20,
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        widget.task.UserId == FirebaseAuth.instance.currentUser.uid
                            ? deleteDialog(context)
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Only the task manager/creator can delete this task'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                        color: Colors.red.shade700,
                      )),
                  IconButton(
                      onPressed: () {
                        widget.task.UserId == FirebaseAuth.instance.currentUser.uid
                            ? finishDialog(context)
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Only the task manager/creator can completely finish this task'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                      },
                      icon: Icon(
                        Icons.check,
                        size: 30,
                        color: Colors.green.shade700,
                      ))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Text(
              widget.task.Name,
              style: GoogleFonts.quicksand(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade900),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              widget.task.Description,
              style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.task.DateDue,
                    style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  widget.task.IsUrgent
                      ? Icon(
                          IconData(0xf65a, fontFamily: iconFont, fontPackage: iconFontPackage),
                          color: Colors.red,
                          size: 25,
                        )
                      : Icon(
                          IconData(0xf65a, fontFamily: iconFont, fontPackage: iconFontPackage),
                          color: Colors.grey,
                          size: 25,
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 80,
              width: 800,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: widget.sharedUsers.length != 0
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 40,
                          width: index != 0
                              ? ((_included[index].username).length * 8) + 118.0
                              : ((_included[index].username).length * 8) + 142.0, // calculation for length acording to if creator and username length
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_included[index].userProfileUrl),
                              ),
                              title: Text(
                                _included[index].username,
                                style: GoogleFonts.quicksand(color: Colors.grey.shade800, fontSize: 16),
                              ),
                              trailing: index == 0
                                  ? Icon(
                                      IconData(0xf052b, fontFamily: 'MaterialIcons'),
                                      color: Colors.yellow.shade700,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                      itemCount: _included.length,
                    )
                  : Center(
                      child: Text(
                        'This task isn\'t shared with anyone',
                        style: GoogleFonts.quicksand(color: Colors.grey.shade700, fontSize: 18),
                      ),
                    ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
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
                      style: GoogleFonts.quicksand(fontSize: 40),
                    ),
                    onPressed: () {
                      _todoController.text.isEmpty
                          ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please add a text to the to do field before adding one'),
                              duration: Duration(seconds: 2),
                            ))
                          : _addTodo(_todoController.text);
                      print(widget.taskTodos);
                      ;
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).accentColor, minimumSize: Size(60, 60), elevation: 6),
                  ),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 370,
                child: ListView(
                  children: [
                    for (Todo todoo in widget.taskTodos)
                      TodoItem(
                        todo: todoo,
                        isDone: _todoDone,
                        onDeleteItem: _deleteToDoItem,
                      )
                  ],
                )),
            ElevatedButton(
                onPressed: () async {
                  for (Todo tudu in _existing) {
                    await Provider.of<TodoProvider>(context, listen: false).deleteTodoItem(tudu.todoId);
                  }
                  for (Todo todo in widget.taskTodos) {
                    await Provider.of<TodoProvider>(context, listen: false).addTodoItems(widget.task.TaskId, todo.text, todo.isDone);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes Were Saved Successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.quicksand(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).accentColor,
                )),
          ]),
        ),
      ),
    );
  }

  finishDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text('Finish task'),
              content: Text(
                'WARNING: You cannot undo this action',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                TextButton(
                  child: Text(
                    'Finish',
                    style: GoogleFonts.quicksand(color: Colors.green.shade800, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    Provider.of<TaskProvider1>(context, listen: false).setAsDone(widget.task.TaskId);
                    for (Todo tudu in widget.taskTodos) {
                      Provider.of<TodoProvider>(context, listen: false).deleteTodoItem(tudu.todoId);
                    }
                    await Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            )));
  }

  deleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text('Delete task'),
              content: Text(
                'WARNING: This action will permanently delete all data',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                TextButton(
                  child: Text(
                    'Delete',
                    style: GoogleFonts.quicksand(color: Colors.red.shade800, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    await Provider.of<TaskProvider1>(context, listen: false).deleteTask(widget.task.TaskId);
                    for (Todo tudu in widget.taskTodos) {
                      Provider.of<TodoProvider>(context, listen: false).deleteTodoItem(tudu.todoId);
                    }
                    for (userTask usertask in widget.sharedUsers) {
                      Provider.of<UserTaskProvider>(context, listen: false).deleteUserTaskItem(usertask.userTaskId);
                    }
                    await Navigator.of(ctx).pop();
                    Navigator.of(context).pop();
                  },
                )
              ],
            )));
  }
}
