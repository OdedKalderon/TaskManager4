import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/todo_item.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todolist = [
    Todo("randomtodoid1", 'KQ0CNENVcc3cUowaDv2j', 'Baloons', false),
    Todo("randomtodoid2", 'KQ0CNENVcc3cUowaDv2j', 'Cake', false)
  ];

  List<Todo> getTaskTodos(String taskUid) {
    List<Todo> taskTodos = [];
    for (int i = 0; i < _todolist.length; i++) {
      if (_todolist[i].taskId == taskUid) {
        taskTodos.add(_todolist[i]);
      }
    }
    return taskTodos;
  }

  List<Todo> get todos {
    return [..._todolist];
  }

  void addTodoItems(String taskid, String inputtext, bool isdone) async {
    await FirebaseFirestore.instance
        .collection('todos')
        .add({'isDone': isdone, 'text': inputtext, 'taskId': taskid}).then(
            (DocumentReference doc) {
      _todolist.add(Todo(doc.id, taskid, inputtext, isdone));
    });
  }

  void deleteTodoItem(String todoId) async {
    await FirebaseFirestore.instance.collection('todos').doc(todoId).delete();
    _todolist.removeWhere((element) => element.todoId == todoId);
  }

  Future<void> fetchTodoData() async {
    _todolist = [];
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
