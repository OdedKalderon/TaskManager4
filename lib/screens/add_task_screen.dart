import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/main_drawer.dart';

import '../providers/authprovider.dart';
import '../providers/taskprovider.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  String _taskDescription = '';
  String _taskDateDue = '';
  bool _taskIsUrgent = false;

  final _descriptionFocusNode = FocusNode();

  void _taskFormSubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      _taskDateDue = DateFormat.yMMMd().format(_selectedDate);
      Provider.of<TaskProvider1>(context, listen: false).submitAddTaskForm(
          _taskName.trim(),
          _taskDescription.trim(),
          _taskDateDue,
          _taskIsUrgent,
          context,
          Provider.of<AuthProvider>(context, listen: false).Userid);
    } else
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could\'nt finish submiting')),
        );
        Navigator.of(context).pop();
        return null;
      };
  }

  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      //row above (41) makes it so the up is always up to date
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _taskDateDue = _selectedDate.toString();
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MainDrawer(),
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
                    validator: (nameValue) {
                      if (nameValue == null || nameValue.trim().isEmpty) {
                        return 'Please enter a name';
                      } else if (nameValue.length > 20) {
                        return 'Name can be up to 20 characters long';
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Add Task Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (nameFieldValue) =>
                        setState(() => _taskName = nameFieldValue),
                    textInputAction: TextInputAction.next,
                    maxLength: 20,
                    onFieldSubmitted: ((_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    validator: (descriptionValue) {
                      if (descriptionValue == null ||
                          descriptionValue.trim().isEmpty) {
                        return 'Please enter a Description';
                      } else if (descriptionValue.length > 80) {
                        return 'Description can be up to 80 characters long';
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Add Task Description',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    maxLength: 80,
                    focusNode: _descriptionFocusNode,
                    onSaved: (descriptionFieldValue) => setState(
                        () => _taskDescription = descriptionFieldValue),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                      ),
                      TextButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _taskFormSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
