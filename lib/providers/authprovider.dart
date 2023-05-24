import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/userc.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  String uid;
  User userData;

  String get Userid {
    return uid;
  }

  List<UserC> get users {
    return [..._users];
  }

  List<UserC> _users = [];

  //input: users data (if sign up first time, also a username)
  //output: if sign up then creates user then adds it to the database
  //        if sign in then checks data with database and if valid sign in
  void submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
          'username': username,
          'email': email,
          'userProfileUrl': 'https://pbs.twimg.com/media/FGCpQkBXMAIqA6d.jpg:large',
        });
      }
      uid = authResult.user.uid;
    } catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  //input: none
  //output: adds to a local memory list all users from database
  Future<void> fetchUsersData() async {
    _users = [];
    await FirebaseFirestore.instance.collection('users').get().then(
      (QuerySnapshot value) {
        value.docs.forEach(
          (result) {
            _users.add(UserC(result.id, result['username'], result['email'], result['userProfileUrl']));
          },
        );
      },
    );
  }

  //input: a picture's url
  //output: sets the singed in user's userProfileUrl as the url inputted in both firebase and local memory
  void setMyProfileUrl(String url) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
      'userProfileUrl': url,
    });
    (_users.firstWhere((element) => element.userId == FirebaseAuth.instance.currentUser.uid)).userProfileUrl = url;
    notifyListeners();
  }

  //input: user id
  //output: returns the whole instance (including the data) of the user with that specific id
  UserC getSpecificUser(String id) {
    return _users.firstWhere((element) => element.userId == id);
  }

  //input: none
  //output: returns the signed in user's username
  String getusername() {
    UserC _temp = _users.firstWhere(
      (user) => user.userId == FirebaseAuth.instance.currentUser.uid,
      orElse: () {
        return null;
      },
    );
    return _temp.username;
  }

  //input: none
  //output: returns the signed in user's email
  String getemail() {
    UserC _temp = _users.firstWhere((user) => user.userId == FirebaseAuth.instance.currentUser.uid);
    return _temp.email;
  }

  //input: none
  //output: returns the signed in user's Profile picture url
  String getProfileUrl() {
    UserC _temp = _users.firstWhere((user) => user.userId == FirebaseAuth.instance.currentUser.uid);
    return _temp.userProfileUrl;
  }
}
