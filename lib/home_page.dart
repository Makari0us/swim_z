// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:swim_z/advice_page.dart';
import 'package:swim_z/log_page.dart';
import 'package:swim_z/nutrition_page.dart';

import 'package:swim_z/search_page.dart';
import 'package:swim_z/bottom_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Advice
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        height: 150,
                        color: Colors.blue,
                      ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 15.0,
                      child: Text(
                        'Advice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      // child: Icon(
                      //   Icons.bubble_chart,
                      //   size: 130.0,
                      //   color: Colors.white,
                      // ),
                      child: Image.asset(
                        'assets/images/advice-icon.png',
                        height: 130.0,
                        width: 130.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Nutrition
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NutritionPage()));
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        height: 150,
                        color: Colors.blue,
                      ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 15.0,
                      child: Text(
                        'Nutrition',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      child: Image.asset(
                        'assets/images/anxiety-icon.png',
                        height: 130.0,
                        width: 130.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Stress
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogPage()));
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        height: 150,
                        color: Colors.blue,
                      ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 15.0,
                      child: Text(
                        'Log Page (Temp)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.0,
                      left: 10.0,
                      child: Image.asset(
                        'assets/images/anxiety-icon.png',
                        height: 130.0,
                        width: 130.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Injury
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 150,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    bottom: 5.0,
                    right: 15.0,
                    child: Text(
                      'Injury',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: Image.asset(
                      'assets/images/injury-icon.png',
                      height: 130.0,
                      width: 130.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            // Environment
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 150,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    bottom: 5.0,
                    right: 15.0,
                    child: Text(
                      'Environment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    left: 10.0,
                    child: Image.asset(
                      'assets/images/environment-icon.png',
                      height: 130.0,
                      width: 130.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
