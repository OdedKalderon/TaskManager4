import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/task.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/user_task.dart';
import '../providers/taskprovider.dart';
import '../widgets/main_drawer.dart';
import '../providers/todoprovider.dart';
import '../providers/usertaskprovider.dart';
import '../widgets/taskitem.dart';
import 'add_task_screen.dart';
import 'display_task_screen.dart';

class UrgentsScreen extends StatelessWidget {
  const UrgentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //input: none
    //output: returns a list of all the tasks that were both shared with the user signed in and their status is urgent and are not done
    List<Task> getShared() {
      List<Task> sharedtasks = [];
      List<userTask> shared = Provider.of<UserTaskProvider>(context, listen: false).getMyUserTasks();
      for (userTask usertask in shared) {
        if (Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId).IsUrgent == true &&
            Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId).isDone == false) {
          sharedtasks.add(Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId));
        }
      }
      return sharedtasks;
    }

    List<Task> Urgs = Provider.of<TaskProvider1>(context, listen: true).urgs;
    List<Task> shared = getShared();
    List<Task> allurgs = Urgs + shared;
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: AssetImage('lib/images/logo.jpg'))),
          ),
          SizedBox(width: 10),
          Text('Urgents', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(pageBuilder: ((context, animation, secondaryAnimation) => AddTaskScreen())));
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: allurgs.isEmpty
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 220,
                  ),
                  Text(
                    'You don\'t have any urgent tasks yet',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('lib/images/smiley_face.png'))),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start adding some by clicking the urgent switch in the task creating & editing page',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(right: 15, bottom: 15, left: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Uncompleted Urgent Tasks',
                        style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      //widget from widgets folder
                      return TaskItem(context: context, AllTasks: allurgs, index: index);
                    },
                    itemCount: allurgs.length,
                  ),
                ],
              )),
    );
  }
}
