import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/user_task.dart';

class UserTaskProvider with ChangeNotifier {
  //a list of SHARED users (that aren't creators)
  List<userTask> _userTasks = [];

  //input: task and user id
  //output: creates and adds the connection in both database and local memory
  void addUserTask(String taskId, String userId) async {
    await FirebaseFirestore.instance.collection('user_tasks').add({
      'taskId': taskId,
      'userId': userId,
    }).then((DocumentReference doc) {
      _userTasks.add(userTask(doc.id, taskId, userId));
    });
  }

  //input: task id
  //output: returns the connections of users for a specific task id
  List<userTask> getTaskUserTasks(String taskid) {
    List<userTask> userTasks = [];
    for (userTask usertask in _userTasks) {
      if (usertask.taskId == taskid) {
        userTasks.add(usertask);
      }
    }
    return userTasks;
  }

  //input: none
  //output: returns a list of connection between tasks and users, that the user signed in is in
  List<userTask> getMyUserTasks() {
    List<userTask> myTasks = [];
    for (int i = 0; i < _userTasks.length; i++) {
      if (_userTasks[i].userId == FirebaseAuth.instance.currentUser.uid) {
        myTasks.add(_userTasks[i]);
      }
    }
    return myTasks;
  }

  //input: connection's id
  //output: deletes the connection from both database and local memory
  void deleteUserTaskItem(String userTaskid) async {
    await FirebaseFirestore.instance.collection('user_tasks').doc(userTaskid).delete();
    _userTasks.removeWhere((element) => element.userTaskId == userTaskid);
  }

  //input: none
  //output: adds to a local memory list all connections between users and tasks from database
  Future<void> fetchUserTaskData() async {
    _userTasks = [];
    await FirebaseFirestore.instance.collection('user_tasks').get().then(
      (QuerySnapshot value) {
        value.docs.forEach(
          (result) {
            _userTasks.add(userTask(
              result.id,
              result["taskId"],
              result["userId"],
            ));
          },
        );
      },
    );
    notifyListeners();
  }
}
