import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/main_drawer.dart';
import 'package:flutter_complete_guide/screens/add_task_screen.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/taskprovider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<TaskProvider1>(context, listen: false).tasks;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        elevation: 2,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index].Name),
                subtitle: tasks[index].Description.length <= 35
                    ? Text(tasks[index].Description)
                    : Text(
                        tasks[index].Description.toString().substring(0, 36) +
                            '...'),
                tileColor: Colors.white,
                trailing: Icon(IconData(0xf5d3,
                    fontFamily: iconFont, fontPackage: iconFontPackage)),
              );
            },
            itemCount: tasks.length,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: ((context, animation, secondaryAnimation) =>
                        AddTaskScreen())));
              },
              backgroundColor: Theme.of(context).buttonColor,
              label: Text(
                'Add Task',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
