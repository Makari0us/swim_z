import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swim_z/auth/login_page.dart';
import 'package:swim_z/pages/assistant_page.dart';
import 'package:swim_z/pages/environment_page.dart';
import 'package:swim_z/pages/home_page.dart';
import 'package:swim_z/pages/journal_page.dart';
import 'package:swim_z/pages/log_page.dart';
import 'package:swim_z/pages/nutrition_page.dart';
import 'package:swim_z/pages/profile_page.dart';
import 'package:swim_z/pages/stress_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomePage(),
    LogPage(),
    AssistantPage(),
    ProfilePage(userID: FirebaseAuth.instance.currentUser!.uid),
    // NutritionPage(),
    // Container(),
    // EnvironmentPage(),
    // StressPage(),
  ];

  final List<String> _pageTitles = [
    'Home',
    'Log',
    'Assistant',
    'Profile',
  ];

  Future<void> _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error loging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          _pageTitles[_currentIndex],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          // _pageController.animateToPage(
          //   index,
          //   duration: Duration(milliseconds: 300),
          //   curve: Curves.easeInOut,
          // );
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
