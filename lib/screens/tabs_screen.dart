import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/providers/socialprovider.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_complete_guide/providers/todoprovider.dart';
import 'package:flutter_complete_guide/providers/usertaskprovider.dart';
import 'package:flutter_complete_guide/screens/acount_screen.dart';
import 'package:flutter_complete_guide/screens/add_task_screen.dart';
import 'package:flutter_complete_guide/screens/social_screen.dart';
import 'package:flutter_complete_guide/screens/urgent_tasks_screen.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/authprovider.dart';
import 'tasks_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key key}) : super(key: key);
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [TasksScreen(), UrgentsScreen(), AddTaskScreen(), SocialScreen(), AcountScreen()];
  int _selectedPageIndex = 0;

  //input: none
  //output: gets from firebase all data necessary for the app,
  //        therefore the app can run in 0 time (except initial load) if no changes were made.
  @override
  void didChangeDependencies() async {
    await Provider.of<AuthProvider>(context, listen: false).fetchUsersData();
    await Provider.of<SocialProvider>(context, listen: false).fetchConnectionData();
    await Provider.of<TaskProvider1>(context, listen: false).fetchTaskData();
    await Provider.of<TodoProvider>(context, listen: false).fetchTodoData();
    await Provider.of<UserTaskProvider>(context, listen: false).fetchUserTaskData();
    super.didChangeDependencies();
  }

  //input: a page index
  //output: sets the tab apearing on screen to the tab indexed with the index that was inputted
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notification_important), label: 'Urgent', backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xf776, fontFamily: iconFont, fontPackage: iconFontPackage)),
              label: 'Add New Task',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xf005c, fontFamily: 'MaterialIcons')), label: 'Social', backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xf419, fontFamily: iconFont, fontPackage: iconFontPackage)),
              label: 'Acount',
              backgroundColor: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
