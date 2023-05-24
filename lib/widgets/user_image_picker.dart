import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/authprovider.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key key, this.onPickImage}) : super(key: key);
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  //input: takes a source to take a picture
  //output: this widget (ImagePicker) either opens the phones camera to take a picture (if source == camera)
  //        or opens phone's gallery to choose a picture (if source == gallery)
  void _pickImage(String source) async {
    final pickedImage = await ImagePicker().pickImage(
        source: source == 'camera' ? ImageSource.camera : ImageSource.gallery, imageQuality: 65, maxWidth: 150); //could be gallery instead of camera
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Don\'t forget to save changes in the SAVE button positioned up right'),
        duration: Duration(seconds: 6),
      ),
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(
            Provider.of<AuthProvider>(context, listen: true).getProfileUrl(),
          ),
          foregroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).backgroundColor,
                ),
                color: Theme.of(context).accentColor,
              ),
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.white,
                onPressed: () {
                  showSourceCameraDialog(context); //defined down this file
                },
              ),
            )),
      ],
    );
  }

  //input: the context of the page
  //output: shows a dialog on the page (via context), and lets the user choose between camera gallery and cancel all actions.
  showSourceCameraDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text('Pick Image Source'),
              content: Text(
                'Where do you want to take your image from?',
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
                TextButton(
                  child: Text('Camera'),
                  onPressed: () async {
                    await _pickImage('camera'); //defined up this file
                    Navigator.of(ctx).pop(true);
                  },
                ),
                TextButton(
                  child: Text('Gallery'),
                  onPressed: () async {
                    await _pickImage('gallery'); //defined up this file
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            )));
  }
}
