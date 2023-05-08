import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/task.dart';

import '../models/todo_item.dart';

class TaskProvider1 with ChangeNotifier {
  List<Task> _Tasks = [
    Task("randomid1", 'Test', 'This is a test task', '14/03/2023', false,
        "7cinqzLA74U0eI8eWiIy5Bj2CeG3"),
    Task("randomid2", 'Test 2', 'This is a test task 2', '31/03/2023', true,
        "7cinqzLA74U0eI8eWiIy5Bj2CeG3"),
    Task("randomid3", 'Test 3', 'This is a test task 3', '15/03/2023', false,
        "7cinqzLA74U0eI8eWiIy5Bj2CeG3"),
  ];

  List<Todo> _todolist = [
    Todo("randomtodoid1", 'KQ0CNENVcc3cUowaDv2j', 'Baloons', false),
    Todo("randomtodoid2", 'KQ0CNENVcc3cUowaDv2j', 'Cake', false)
  ];

  List<Task> _urgentTasks = [];

  void getUrgents() {
    for (int i = 0; i < _Tasks.length; i++) {
      if (_Tasks[i].IsUrgent == true) {
        _urgentTasks.add(_Tasks[i]);
      }
    }
  }

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  List<Task> get tasks {
    return [..._Tasks];
  }

  List<Todo> get todos {
    return [..._todolist];
  }

  List<Task> get urgs {
    return [..._urgentTasks];
  }

  void addTodoItems(
      String taskid, String inputtext, bool isdone, String tempid) async {
    await _database
        .collection('todos')
        .add({'isDone': isdone, 'text': inputtext, 'taskId': taskid});
    _todolist.add(Todo(null, tempid, inputtext, isdone));
  }

  Future<String> submitAddTaskForm(
      String name,
      String description,
      String dateDue,
      bool isUrgent,
      BuildContext ctx,
      String Userid,
      String tempid) async {
    try {
      await _database.collection('tasks').add({
        'Name': name,
        'Description': description,
        'DateDue': dateDue,
        'IsUrgent': isUrgent,
        'UserId': Userid,
      }).then((DocumentReference doc) {
        return doc.id;
      });
      _Tasks.add(Task(tempid, name, description, dateDue, isUrgent, Userid));
    } on PlatformException catch (err) {
      var message =
          'An error occurred, please check the information you inputed or try again later';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  Future<void> fetchTaskData() async {
    await FirebaseFirestore.instance.collection('tasks').get().then(
      (QuerySnapshot value) {
        value.docs.forEach(
          (result) {
            _Tasks.add(Task(result.id, result["Name"], result["Description"],
                result["DateDue"], result["IsUrgent"], result["UserId"]));
          },
        );
      },
    );
    notifyListeners();
  }

  Future<void> fetchTodoData() async {
    await FirebaseFirestore.instance
        .collection('todos')
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((result) {
        _todolist.add(Todo(
            result.id, result['taskId'], result['text'], result['isDone']));
      });
    });
    notifyListeners();
  }
}
