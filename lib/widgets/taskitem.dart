import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/todoprovider.dart';
import '../providers/usertaskprovider.dart';
import '../screens/display_task_screen.dart';

class TaskItem extends StatefulWidget {
  final BuildContext context;
  final List<Task> AllTasks;
  final int index;

  const TaskItem({Key key, @required this.context, @required this.AllTasks, @required this.index}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            onTap: () {
              //pushes a different screen whil forwarding some data, such as task[index] instance, todos, and shared users with it.
              Navigator.push(
                  widget.context,
                  MaterialPageRoute(
                      builder: ((ctx) => DisplayTaskScreen(
                            task: widget.AllTasks[widget.index],
                            taskTodos: Provider.of<TodoProvider>(ctx, listen: false).getTaskTodos(widget.AllTasks[widget.index].TaskId),
                            sharedUsers: Provider.of<UserTaskProvider>(ctx, listen: false).getTaskUserTasks(widget.AllTasks[widget.index].TaskId),
                          ))));
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            title: widget.AllTasks[widget.index].IsUrgent
                ? Row(
                    children: [
                      Text(
                        widget.AllTasks[widget.index].Name,
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                      ),
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
                      Text(
                        widget.AllTasks[widget.index].Name,
                        style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                      ),
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
            subtitle: widget.AllTasks[widget.index].Description.length <= 35
                ? Text(
                    widget.AllTasks[widget.index].Description + '\nDate Due To: ' + widget.AllTasks[widget.index].DateDue,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                  )
                : Text(
                    widget.AllTasks[widget.index].Description.toString().substring(0, 36) +
                        '... \n' +
                        'Date Due To: ' +
                        widget.AllTasks[widget.index].DateDue,
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                  ),
            tileColor: Colors.white,
            trailing: Icon(IconData(0xf5d3, fontFamily: iconFont, fontPackage: iconFontPackage)),
          ),
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}
