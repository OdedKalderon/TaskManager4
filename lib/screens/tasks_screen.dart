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
              return Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg",
                      ),
                      title: tasks[index].IsUrgent
                          ? Row(
                              children: [
                                Text(tasks[index].Name),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  IconData(0xf65a,
                                      fontFamily: iconFont,
                                      fontPackage: iconFontPackage),
                                  color: Colors.red,
                                  size: 20,
                                )
                              ],
                            )
                          : Row(
                              children: [
                                Text(tasks[index].Name),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  IconData(0xf65a,
                                      fontFamily: iconFont,
                                      fontPackage: iconFontPackage),
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ],
                            ),
                      subtitle: tasks[index].Description.length <= 35
                          ? Text(
                              tasks[index].Description +
                                  '\nDate Due To: ' +
                                  tasks[index].DateDue,
                            )
                          : Text(tasks[index]
                                  .Description
                                  .toString()
                                  .substring(0, 36) +
                              '... \n' +
                              'Date Due To: ' +
                              tasks[index].DateDue),
                      tileColor: Colors.white,
                      trailing: Icon(IconData(0xf5d3,
                          fontFamily: iconFont, fontPackage: iconFontPackage)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
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
