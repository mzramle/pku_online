import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/page/home_page.dart';

class NavBarRoots extends StatefulWidget {
  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    // Home Screen
    HomePage(),
    // Schedule Screen
    Container(),
    // Report Screen
    Container(),
    // Notifications Screen
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              label: "Schedule",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: "Report",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notification_add),
              label: "Notifications",
            ),
          ],
        ),
      ),
    );
  }
}
