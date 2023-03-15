import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/task.dart';

class TaskProvider1 with ChangeNotifier {
  List<Task> _Tasks = [
    Task('Test', 'This is a test task', '14/03/2023', false),
  ];

  final _auth = FirebaseAuth.instance;
  final _base = FirebaseFirestore.instance;

  List<Task> get tasks {
    return [..._Tasks];
  }

  List<Task> getTasks() {
    return _Tasks;
  }
}
