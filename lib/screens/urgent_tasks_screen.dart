import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/task.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user_task.dart';
import '../providers/taskprovider.dart';
import '../main_drawer.dart';
import '../providers/todoprovider.dart';
import '../providers/usertaskprovider.dart';
import 'add_task_screen.dart';
import 'display_task_screen.dart';

class UrgentsScreen extends StatelessWidget {
  const UrgentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //input: none
    //output: returns a list of all the tasks that were both shared with the user signed in and their status is urgent
    List<Task> getShared() {
      List<Task> sharedtasks = [];
      List<userTask> shared = Provider.of<UserTaskProvider>(context, listen: false).getMyUserTasks();
      for (userTask usertask in shared) {
        if (Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId).IsUrgent == true) {
          sharedtasks.add(Provider.of<TaskProvider1>(context, listen: false).getSpecificTask(usertask.taskId));
        }
      }
      return sharedtasks;
    }

    List<Task> Urgs = Provider.of<TaskProvider1>(context, listen: false).urgs;
    List<Task> shared = getShared();
    List<Task> allurgs = Urgs + shared;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urgents', style: TextStyle(fontWeight: FontWeight.w600)),
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
                  const Text(
                    'You don\'t have any urgent tasks yet',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    'https://static-00.iconduck.com/assets.00/relieved-face-emoji-512x512-f4bxb1mm.png',
                    height: 115,
                    width: 115,
                  ),
                  SizedBox(height: 10),
                  const Text(
                    'Start adding some by clicking the urgent switch in the task creating & editing page',
                    style: TextStyle(
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => DisplayTaskScreen(
                                          task: allurgs[index],
                                          taskTodos: Provider.of<TodoProvider>(context, listen: false).getTaskTodos(allurgs[index].TaskId),
                                          sharedUsers:
                                              Provider.of<UserTaskProvider>(context, listen: false).getTaskUserTasks(allurgs[index].TaskId)))));
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            title: allurgs[index].IsUrgent
                                ? Row(
                                    children: [
                                      Text(allurgs[index].Name),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        IconData(0xf65a, fontFamily: iconFont, fontPackage: iconFontPackage),
                                        color: Colors.red,
                                        size: 20,
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(allurgs[index].Name),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        IconData(0xf65a, fontFamily: iconFont, fontPackage: iconFontPackage),
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                            subtitle: allurgs[index].Description.length <= 35
                                ? Text(
                                    allurgs[index].Description + '\nDate Due To: ' + allurgs[index].DateDue,
                                  )
                                : Text(allurgs[index].Description.toString().substring(0, 36) + '... \n' + 'Date Due To: ' + allurgs[index].DateDue),
                            tileColor: Colors.white,
                            trailing: Icon(IconData(0xf5d3, fontFamily: iconFont, fontPackage: iconFontPackage)),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    itemCount: allurgs.length,
                  ),
                ],
              )),
    );
  }
}
