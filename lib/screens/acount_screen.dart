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
    String _userName =
        Provider.of<AuthProvider>(context, listen: true).getusername();
    String _email = Provider.of<AuthProvider>(context, listen: true).getemail();
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
                final imageUrl = await FirebaseStorage.instance
                    .ref()
                    .child('user_images')
                    .child('${FirebaseAuth.instance.currentUser.uid}.jpg')
                    .getDownloadURL();
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .update({
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
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
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    width: 280,
                    height: 400,
                    child: Text('2 week history tasks '),
                    //THIS WILL BE CHANGED WITH A SCROLLABLE
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
