import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/todo_item.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todolist = [];

  //input: task id
  //output: returns a list of Todo items that are related to the task
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

  //input: Todo item's data
  //output: creates and adds the Todo item in both database and local memory
  void addTodoItems(String taskid, String inputtext, bool isdone) async {
    await FirebaseFirestore.instance.collection('todos').add({'isDone': isdone, 'text': inputtext, 'taskId': taskid}).then((DocumentReference doc) {
      _todolist.add(Todo(doc.id, taskid, inputtext, isdone));
    });
  }

  //input: Todo item's id
  //output: deletes the Todo item from both database and local memory
  void deleteTodoItem(String todoId) async {
    await FirebaseFirestore.instance.collection('todos').doc(todoId).delete();
    _todolist.removeWhere((element) => element.todoId == todoId);
  }

  //input: none
  //output: adds to a local memory list all Todo items from database
  Future<void> fetchTodoData() async {
    _todolist = [];
    await FirebaseFirestore.instance.collection('todos').get().then((QuerySnapshot value) {
      value.docs.forEach((result) {
        _todolist.add(Todo(result.id, result['taskId'], result['text'], result['isDone']));
      });
    });
    notifyListeners();
  }
}
