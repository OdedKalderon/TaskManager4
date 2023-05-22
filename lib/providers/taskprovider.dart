import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/models/task.dart';
import 'package:flutter_complete_guide/models/userc.dart';

import '../models/todo_item.dart';

class TaskProvider1 with ChangeNotifier {
  List<Task> _Tasks = [];

  //input: none
  //output: a list of all the tasks that both the user that is signed in created and their status equals urgent.
  List<Task> getUrgents() {
    List<Task> urgentTasks2 = [];
    for (int i = 0; i < _Tasks.length; i++) {
      if (_Tasks[i].IsUrgent == true && _Tasks[i].UserId == FirebaseAuth.instance.currentUser.uid) {
        urgentTasks2.add(_Tasks[i]);
      }
    }
    return urgentTasks2;
  }

  //input: none
  //output: a list of all the tasks that the user that is signed in created.
  List<Task> getMyTasks() {
    List<Task> myTasks = [];
    for (int i = 0; i < _Tasks.length; i++) {
      if (_Tasks[i].UserId == FirebaseAuth.instance.currentUser.uid) {
        myTasks.add(_Tasks[i]);
      }
    }
    return myTasks;
  }

  //input: task id
  //outhput: returns the whole instance (including the data) of the task with that specific id
  Task getSpecificTask(String id) {
    return _Tasks.firstWhere((element) => element.TaskId == id);
  }

  //input: task id
  //outhput: the id of the user who created the task with that specific task id
  String getTaskManagerId(String taskid) {
    return ((_Tasks.firstWhere((element) => element.TaskId == taskid)).UserId);
  }

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  List<Task> get tasks {
    return [..._Tasks];
  }

  List<Task> get urgs {
    return getUrgents();
  }

  //input: task's id
  //output: deletes the task from both database and local memory
  void deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    _Tasks.removeWhere((element) => element.TaskId == taskId);
    notifyListeners();
  }

  //input: task data from a form and the context of it
  //output: tries to submit form then, creates the task, adds it to database and local memory, then returns the task's id (that was just created).
  //        if cannot submit form an error message apears
  Future<String> submitAddTaskForm(
    String name,
    String description,
    String dateDue,
    bool isUrgent,
    BuildContext ctx,
    String Userid,
  ) async {
    try {
      String docid;
      await _database.collection('tasks').add({
        'Name': name,
        'Description': description,
        'DateDue': dateDue,
        'IsUrgent': isUrgent,
        'UserId': Userid,
      }).then((DocumentReference doc) {
        _Tasks.add(Task(doc.id, name, description, dateDue, isUrgent, Userid));
        docid = doc.id;
      });
      return docid;
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check the information you inputed or try again later';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  //input: none
  //output: adds to a local memory list all Tasks from database
  Future<void> fetchTaskData() async {
    _Tasks = [];
    await FirebaseFirestore.instance.collection('tasks').get().then(
      (QuerySnapshot value) {
        value.docs.forEach(
          (result) {
            _Tasks.add(Task(result.id, result["Name"], result["Description"], result["DateDue"], result["IsUrgent"], result["UserId"]));
          },
        );
      },
    );
    notifyListeners();
  }
}
