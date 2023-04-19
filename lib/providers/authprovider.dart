import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  String uid;

  String get Userid {
    return uid;
  }

  // Future<User> fetchUserData(String userid) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot value) {
  //     value.docs.forEach((result) {
  //       userid == result['userId'] ? return User(result['userid'], result['username'], result['email']) : return null;
  //     });
  //   });
  //   notifyListeners();
  // }

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
          'userId': authResult.user.uid,
          'username': username,
          'email': email,
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

  notifyListeners();
}
