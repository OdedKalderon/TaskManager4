import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../models/todo_item.dart';
import '../widgets/todoItem.dart';

class DisplayTaskScreen extends StatefulWidget {
  final Task task;
  const DisplayTaskScreen({Key key, @required this.task}) : super(key: key);

  @override
  State<DisplayTaskScreen> createState() => _DisplayTaskScreenState();
}

class _DisplayTaskScreenState extends State<DisplayTaskScreen> {
  List<Todo> myTodos = [];
  List<Todo> updatedTodos = [];
  final _todoController = TextEditingController();

  void _todoDone(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String todoText) {
    setState(() {
      myTodos.removeWhere((item) => item.text == todoText);
    });
  }

  void _addTodo(String todo) {
    setState(() {
      updatedTodos.add(Todo(DateTime.now().millisecondsSinceEpoch.toString(),
          widget.task.TaskId, todo, false));
      _todoController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> allTodos =
        Provider.of<TaskProvider1>(context, listen: false).todos;
    myTodos = updatedTodos = Provider.of<TaskProvider1>(context, listen: false)
        .getTaskTodos(widget.task.TaskId, allTodos);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Task Details', style: TextStyle(fontWeight: FontWeight.w400)),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 25,
          ),
          Text(
            widget.task.Name,
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            widget.task.Description,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700),
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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 10,
                ),
                widget.task.IsUrgent
                    ? Icon(
                        IconData(0xf65a,
                            fontFamily: iconFont, fontPackage: iconFontPackage),
                        color: Colors.red,
                        size: 25,
                      )
                    : Icon(
                        IconData(0xf65a,
                            fontFamily: iconFont, fontPackage: iconFontPackage),
                        color: Colors.grey,
                        size: 25,
                      ),
              ],
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
                        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                      backgroundColor: Theme.of(context).accentColor,
                      minimumSize: Size(60, 60),
                      elevation: 6),
                ),
              )
            ],
          ),
          Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 350,
              child: ListView(
                children: [
                  for (Todo todoo in updatedTodos)
                    TodoItem(
                      todo: todoo,
                      isDone: _todoDone,
                      onDeleteItem: _deleteToDoItem,
                    )
                ],
              )),
        ]),
      ),
    );
  }
}
