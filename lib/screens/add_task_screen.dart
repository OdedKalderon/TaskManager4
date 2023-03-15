import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/main_drawer.dart';

import 'package:flutter_complete_guide/providers/Taskprovider.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  var _taskName = '';
  var _taskDescription = '';
  var _taskDateDue = '';
  var _taskIsUrgent = false;

  final _descriptionFocusNode = FocusNode();

  void _taskFormSubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  TextFormField(
                    key: ValueKey('taskName'),
                    validator: (nameValue) {
                      if (nameValue == null || nameValue.isEmpty) {
                        return 'Please enter a name';
                      } else if (nameValue.length > 20) {
                        return 'Name can be up to 20 characters long';
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Add Task Name',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    onFieldSubmitted: ((_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    }),
                  ),
                  TextFormField(
                    key: ValueKey('taskDescription'),
                    validator: (descriptionValue) {
                      if (descriptionValue == null ||
                          descriptionValue.isEmpty) {
                        return 'Please enter a Description';
                      } else if (descriptionValue.length > 80) {
                        return 'Description can be up to 80 characters long';
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Add Task Description',
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 80,
                    focusNode: _descriptionFocusNode,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //remind to add focusNode: _iconFocusNode => to icon picker field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState.validate()) {
                  //   Provider.of<CategoryProvider>(context, listen: false)
                  //       .addCategory();
                  // } else
                  //   () {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(
                  //           content: Text('Could\'nt finish submiting')),
                  //     );
                  //     Navigator.of(context).pop();
                  //     return null;
                  //   };
                },
                child: const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
