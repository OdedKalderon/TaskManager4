import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key key, this.onPickImage}) : super(key: key);
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150); //could be gallery instead of camera
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Don\'t forget to save changes in the SAVE button positioned up right'),
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
          backgroundImage: _pickedImageFile == null
              ? NetworkImage(
                  "https://pbs.twimg.com/media/FGCpQkBXMAIqA6d.jpg:large",
                )
              : null, //NetworkImage(get current user userProfileUrl)
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
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
                onPressed: _pickImage,
              ),
            )),
      ],
    );
  }
}
