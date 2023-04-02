import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/task.dart';

class TaskProvider1 with ChangeNotifier {
  List<Task> _Tasks = [
    Task('Test', 'This is a test task', '14/03/2023', false),
    Task('Test 2', 'This is a test task 2', '31/03/2023', true),
    Task('Test 3', 'This is a test task 3', '15/03/2023', false),
    Task('Test 4', 'This is a test task 4', '16/03/2023', false),
    Task('Test 5', 'This is a test task 5', '17/03/2023', false),
    Task('Test 6', 'This is a test task 6', '18/03/2023', true),
  ];
  List<Task> _urgentTasks = [];

  List<Task> getUrgents() {
    fetchTaskData();
    for (int i = 0; i < _Tasks.length; i++) {
      if (_Tasks[i].IsUrgent == true) {
        _urgentTasks.add(_Tasks[i]);
      }
    }
    return [..._urgentTasks];
  }

  final _auth = FirebaseAuth.instance;

  List<Task> get tasks {
    fetchTaskData();
    return [..._Tasks];
  }

  List<Task> get urgs {
    fetchTaskData();
    getUrgents();
    return [..._urgentTasks];
  }

  // void submitAddTaskForm(
  //     String name, String description, String dateDue, bool isUrgent) async {
  //   // _Tasks.add(Task(name, description, dateDue, isUrgent));
  //   await _base.collection('tasks').doc().set({
  //     'name': name,
  //     'description': description,
  //     'dateDue': dateDue,
  //     'isUrgent': isUrgent
  //   });
  // }

  Future<void> fetchTaskData() async {
    try {
      await FirebaseFirestore.instance.collection('tasks').get().then(
        (QuerySnapshot value) {
          value.docs.forEach(
            (result) {
              _Tasks.add(Task(result["Name"], result["Description"],
                  result["DateDue"], result["IsUrgent"]));
            },
          );
        },
      );
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
