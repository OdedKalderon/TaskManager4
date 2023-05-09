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

  List<UserC> _users = [];

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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': username,
          'email': email,
          'userProfileUrl':
              'https://pbs.twimg.com/media/FGCpQkBXMAIqA6d.jpg:large',
        });
      }
      uid = authResult.user.uid;
    } on PlatformException catch (err) {
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

  Future<void> fetchUsersData() async {
    await FirebaseFirestore.instance.collection('users').get().then(
      (QuerySnapshot value) {
        value.docs.forEach(
          (result) {
            _users.add(UserC(result.id, result['username'], result['email'],
                result['userProfileUrl']));
          },
        );
      },
    );
  }

  String getusername() {
    UserC _temp = _users.firstWhere(
      (user) => user.userId == FirebaseAuth.instance.currentUser.uid,
      orElse: () {
        return null;
      },
    );
    return _temp.username;
  }

  String getemail() {
    UserC _temp = _users.firstWhere(
        (user) => user.userId == FirebaseAuth.instance.currentUser.uid);
    return _temp.email;
  }
}
