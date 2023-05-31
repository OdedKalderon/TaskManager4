import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/main_drawer.dart';
import 'package:flutter_complete_guide/models/user_task.dart';
import 'package:flutter_complete_guide/providers/todoprovider.dart';
import 'package:flutter_complete_guide/providers/usertaskprovider.dart';
import 'package:flutter_complete_guide/screens/add_task_screen.dart';
import 'package:flutter_complete_guide/screens/display_task_screen.dart';
import '../widgets/taskitem.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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
    //input: none
    //output: returns a list of all the tasks that were shared with the user signed in, and are not done
    List<Task> getShared() {
      List<Task> sharedtasks = [];
      List<userTask> shared = Provider.of<UserTaskProvider>(context, listen: true).getMyUserTasks();
      for (userTask usertask in shared) {
        if (Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId).isDone == false) {
          sharedtasks.add(Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId));
        }
      }
      return sharedtasks;
    }

    List<Task> Mytasks = Provider.of<TaskProvider1>(context, listen: true).getMyTasks();
    List<Task> Sharedtasks = getShared();
    List<Task> AllTasks = Mytasks + Sharedtasks;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage('lib/images/logo.jpg'))),
            ),
            SizedBox(width: 10),
            Text('All Tasks', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(pageBuilder: ((context, animation, secondaryAnimation) => AddTaskScreen())));
            },
          )
        ],
        elevation: 2,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: !AllTasks.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Uncompleted Tasks',
                          style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 380,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          //widget from widgets folder
                          return TaskItem(context: context, AllTasks: AllTasks, index: index);
                        },
                        itemCount: AllTasks.length,
                      ),
                    ),
                  ],
                ),
              ))
          : Center(
              child: Text('You don\'t have any tasks to be done\nstart adding some!',
                  style: GoogleFonts.quicksand(fontSize: 20), textAlign: TextAlign.center)),
    );
  }
}
