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

  @override
  Widget build(BuildContext context) {
    List<Todo> allTodos =
        Provider.of<TaskProvider1>(context, listen: false).todos;
    myTodos = Provider.of<TaskProvider1>(context, listen: false)
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
                        size: 20,
                      )
                    : Icon(
                        IconData(0xf65a,
                            fontFamily: iconFont, fontPackage: iconFontPackage),
                        color: Colors.grey,
                        size: 20,
                      ),
                Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 240,
                    child: ListView(
                      children: [
                        for (Todo todoo in myTodos)
                          TodoItem(
                            todo: todoo,
                            isDone: _todoDone,
                            onDeleteItem: _deleteToDoItem,
                          )
                      ],
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
