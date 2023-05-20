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
        "zBrn5No3OQdzKeJXsDlsyIrgCcX2"),
    Task("randomid2", 'Test 2', 'This is a test task 2', '31/03/2023', true,
        "zBrn5No3OQdzKeJXsDlsyIrgCcX2"),
  ];

  List<Task> getUrgents() {
    List<Task> urgentTasks2 = [];
    for (int i = 0; i < _Tasks.length; i++) {
      if (_Tasks[i].IsUrgent == true &&
          _Tasks[i].UserId == FirebaseAuth.instance.currentUser.uid) {
        urgentTasks2.add(_Tasks[i]);
      }
    }
    return urgentTasks2;
  }

  List<Task> getMyTasks() {
    List<Task> myTasks = [];
    for (int i = 0; i < _Tasks.length; i++) {
      if (_Tasks[i].UserId == FirebaseAuth.instance.currentUser.uid) {
        myTasks.add(_Tasks[i]);
      }
    }
    return myTasks;
  }

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  List<Task> get tasks {
    return [..._Tasks];
  }

  List<Task> get urgs {
    return getUrgents();
  }

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
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<void> fetchTaskData() async {
    _Tasks = [];
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
}
