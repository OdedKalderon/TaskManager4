import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/user_task.dart';

class UserTaskProvider with ChangeNotifier {
  List<userTask> _userTasks = [];

  void addUserTask(String taskId, String userId) async {
    await FirebaseFirestore.instance.collection('user_tasks').add({
      'taskId': taskId,
      'userId': userId,
    }).then((DocumentReference doc) {
      _userTasks.add(userTask(doc.id, taskId, userId));
    });
  }

  List<userTask> getTaskUserTasks(String taskid) {
    List<userTask> userTasks = [];
    for (userTask usertask in _userTasks) {
      if (usertask.taskId == taskid) {
        userTasks.add(usertask);
      }
    }
    return userTasks;
  }

  List<userTask> getMyUserTasks() {
    List<userTask> myTasks = [];
    for (int i = 0; i < _userTasks.length; i++) {
      if (_userTasks[i].userId == FirebaseAuth.instance.currentUser.uid) {
        myTasks.add(_userTasks[i]);
      }
    }
    return myTasks;
  }

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
