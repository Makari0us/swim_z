import 'package:flutter/material.dart';
import 'package:swim_z/pages/assistant_page.dart';
import 'package:swim_z/pages/home_page.dart';
import 'package:swim_z/pages/journal_page.dart';
import 'package:swim_z/pages/log_page.dart';
import 'package:swim_z/pages/nutrition_page.dart';
import 'package:swim_z/pages/profile_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    LogPage(),
    AssistantPage(),
    JournalPage(),
    NutritionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant),
            label: 'Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
