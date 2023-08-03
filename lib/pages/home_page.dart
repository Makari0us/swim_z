import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swim_z/pages/environment_page.dart';
import 'package:swim_z/pages/nutrition_page.dart';
import 'package:swim_z/pages/profile_page.dart';
import 'package:swim_z/pages/search_page.dart';
import 'package:swim_z/pages/stress_page.dart';

import 'log_page.dart';

// import 'bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int currentIndex = 0;
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  // void onTap(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  Widget buildSection(String title, String imageAsset, Widget page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 100,
                color: Colors.blue,
              ),
            ),
            Positioned(
              bottom: 5.0,
              right: 15.0,
              child: Text(
                title,
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
                'assets/images/$imageAsset',
                height: 70.0,
                width: 70.0,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
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
            buildSection('Advice', 'advice-icon.png', SearchPage()),
            buildSection('Nutrition', 'anxiety-icon.png', NutritionPage()),
            buildSection('Log Page', 'anxiety-icon.png', LogPage()),
            buildSection('Profile Page', 'anxiety-icon.png',
                ProfilePage(userID: userUID)),
            buildSection('Injury', 'injury-icon.png',
                Container()), // Replace 'Container()' with the actual injury page.
            buildSection(
                'Environment', 'environment-icon.png', EnviromentPage()),
            buildSection('Stress', 'advice-icon.png', StressPage()),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: currentIndex,
      //   onTap: onTap,
      // ),
    );
  }
}
