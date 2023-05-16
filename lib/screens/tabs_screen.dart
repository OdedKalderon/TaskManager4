import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/providers/taskprovider.dart';
import 'package:flutter_complete_guide/screens/acount_screen.dart';
import 'package:flutter_complete_guide/screens/social_screen.dart';
import 'package:flutter_complete_guide/screens/add_task_tab.dart';
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
  final List<Widget> _pages = [
    TasksScreen(),
    UrgentsScreen(),
    AddTaskTab(),
    SocialScreen(),
    AcountScreen()
  ];
  int _selectedPageIndex = 3;

  @override
  void didChangeDependencies() async {
    await Provider.of<TaskProvider1>(context, listen: false).fetchTaskData();
    await Provider.of<TaskProvider1>(context, listen: false).fetchTodoData();
    await Provider.of<AuthProvider>(context, listen: false).fetchUsersData();
    super.didChangeDependencies();
  }

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
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_important),
              label: 'Urgent',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xf776,
                  fontFamily: iconFont, fontPackage: iconFontPackage)),
              label: 'Add New Task',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xf005c, fontFamily: 'MaterialIcons')),
              label: 'Social',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xf419,
                  fontFamily: iconFont, fontPackage: iconFontPackage)),
              label: 'Acount',
              backgroundColor: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
