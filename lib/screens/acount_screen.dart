import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/finished_task.dart';
import 'package:flutter_complete_guide/models/user_task.dart';
import 'package:flutter_complete_guide/providers/finishedprovider.dart';
import 'package:flutter_complete_guide/providers/usertaskprovider.dart';
import 'package:flutter_complete_guide/widgets/user_image_picker.dart';
import 'package:provider/provider.dart';

import '../main_drawer.dart';
import '../providers/authprovider.dart';
import '../models/userc.dart';

class AcountScreen extends StatefulWidget {
  const AcountScreen({Key key}) : super(key: key);

  @override
  State<AcountScreen> createState() => _AcountScreenState();
}

class _AcountScreenState extends State<AcountScreen> {
  File _selectedImage;

  @override
  Widget build(BuildContext context) {
    String _userName = Provider.of<AuthProvider>(context, listen: false).getusername();
    String _email = Provider.of<AuthProvider>(context, listen: false).getemail();

    List<FinishedTask> getMyFinishedTasks() {
      List<FinishedTask> myFinishedTasks = [];
      List<userTask> myUserTasks = Provider.of<UserTaskProvider>(context, listen: true).getMyUserTasks();
      List<FinishedTask> allFinishedTasks = Provider.of<FinishedProvider>(context, listen: true).finished;
      for (FinishedTask finishedtask in allFinishedTasks) {
        for (userTask usertask in myUserTasks) {
          if (finishedtask.taskId == usertask.taskId || finishedtask.userId == FirebaseAuth.instance.currentUser.uid) {
            myFinishedTasks.add(finishedtask);
          }
        }
      }
      return myFinishedTasks;
    }

    List<FinishedTask> _myFinished = getMyFinishedTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Acount', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(IconData(0xf0563, fontFamily: 'MaterialIcons')),
            onPressed: () async {
              if (_selectedImage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No Changes were made'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                await FirebaseStorage.instance
                    .ref()
                    .child('user_images')
                    .child('${FirebaseAuth.instance.currentUser.uid}.jpg')
                    .putFile(_selectedImage);
                final imageUrl =
                    await FirebaseStorage.instance.ref().child('user_images').child('${FirebaseAuth.instance.currentUser.uid}.jpg').getDownloadURL();
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
                  'userProfileUrl': imageUrl,
                });
              }
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Column(
          children: [
            Center(child: UserImagePicker(
              onPickImage: ((pickedImage) {
                _selectedImage = pickedImage;
              }),
            )),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  '@' + _userName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(_email, style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(15)),
                  alignment: Alignment.center,
                  width: 280,
                  height: 400,
                  child: _myFinished.length != 0
                      ? ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey.shade900, offset: Offset(4, 4), blurRadius: 15, spreadRadius: 1)]),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Column(children: [
                                Text(
                                  _myFinished[index].taskName,
                                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                                ),
                                Text(
                                  _myFinished[index].dateDue,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                ),
                                Text(
                                  _myFinished[index].dateFinished,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                )
                              ]),
                            );
                          },
                          itemCount: _myFinished.length,
                        )
                      : Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              'You don\'t have any\nfinished tasks yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22, color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
