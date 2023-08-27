import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swim_z/pages/assistant_page.dart';
import 'package:swim_z/pages/environment_page.dart';
import 'package:swim_z/pages/nutrition_page.dart';
import 'package:swim_z/pages/profile_page.dart';
import 'package:swim_z/pages/search_page.dart';
import 'package:swim_z/pages/stress_page.dart';
import 'log_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Widget buildSection(String title, String imageAsset, String bgImageAsset, Widget page) {
  Widget buildSection(String title, String bgImageAsset, Widget page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'assets/images/$bgImageAsset', // Background image
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 5.0,
                left: 15.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? userName = FirebaseAuth.instance.currentUser!.displayName;

    return Scaffold(
      // backgroundColor: Colors.blue[200],
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // buildSection('Nutrition', 'anxiety-icon.png', 'nutrition-bg.jpg',
              //     NutritionPage()),
              // buildSection('Environment', 'environment-icon.png',
              //     'environment-bg.jpg', EnvironmentPage()),
              // buildSection(
              //     'Stress', 'advice-icon.png', 'stress-bg.jpg', StressPage()),

              buildSection('Nutrition', 'nutrition2-bg.jpg', NutritionPage()),
              buildSection(
                  'Environment', 'environment-bg.jpg', EnvironmentPage()),
              buildSection('Stress', 'stress-bg.jpg', StressPage()),
            ],
          ),
        ),
      ),
    );
  }
}
