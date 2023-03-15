import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_complete_guide/screens/acount_screen.dart';
import 'package:flutter_complete_guide/screens/inbox_screen.dart';
import 'package:flutter_complete_guide/screens/share__screen.dart';
import 'package:flutter_complete_guide/screens/urgent_tasks_screen.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/Cupertino.dart';
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
    ShareScreen(),
    InboxScreen(),
    AcountScreen()
  ];
  int _selectedPageIndex = 0;

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
            icon: Icon(Icons.category),
            label: 'Categories',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_important),
              label: 'Urgent',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: 'Share',
              backgroundColor: Theme.of(context).primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
              label: 'Inbox',
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
