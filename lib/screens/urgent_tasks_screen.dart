import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/models/task.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/taskprovider.dart';
import '../main_drawer.dart';
import 'display_task_screen.dart';

class UrgentsScreen extends StatelessWidget {
  const UrgentsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Task> urgs = Provider.of<TaskProvider1>(context, listen: false).urgs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urgents',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: MainDrawer(),
      body: urgs.isEmpty
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                          task: urgs[index]))));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            title: urgs[index].IsUrgent
                                ? Row(
                                    children: [
                                      Text(urgs[index].Name),
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
                                      Text(urgs[index].Name),
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
                            subtitle: urgs[index].Description.length <= 35
                                ? Text(
                                    urgs[index].Description +
                                        '\nDate Due To: ' +
                                        urgs[index].DateDue,
                                  )
                                : Text(urgs[index]
                                        .Description
                                        .toString()
                                        .substring(0, 36) +
                                    '... \n' +
                                    'Date Due To: ' +
                                    urgs[index].DateDue),
                            tileColor: Colors.white,
                            trailing: Icon(IconData(0xf5d3,
                                fontFamily: iconFont,
                                fontPackage: iconFontPackage)),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    itemCount: urgs.length,
                  ),
                ],
              )),
    );
  }
}
