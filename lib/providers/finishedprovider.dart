import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/models/finished_task.dart';

class FinishedProvider with ChangeNotifier {
  List<FinishedTask> _finished = [];

  List<FinishedTask> get finished {
    return [..._finished];
  }

  void addFinishedTask(String taskid, String userid, String taskname, String datedue, String datefinished) async {
    await FirebaseFirestore.instance.collection('finished_tasks').add(
        {'userId': userid, 'taskId': taskid, 'taskName': taskname, 'dateDue': datedue, 'dateFinished': datefinished}).then((DocumentReference doc) {
      _finished.add(FinishedTask(doc.id, userid, taskid, taskname, datedue, datefinished));
    });
    notifyListeners();
  }

  Future<void> fetchFinishedData() async {
    //stupid
    _finished = [];
    await FirebaseFirestore.instance.collection('finished_tasks').get().then((QuerySnapshot value) => value.docs.forEach((element) {
          _finished
              .add(FinishedTask(element.id, element['userId'], element['taskId'], element['taskName'], element['dateDue'], element['dateFinished']));
        }));
    notifyListeners();
  }
}
