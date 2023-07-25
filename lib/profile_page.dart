// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // String name = '';
  // int age = 0;
  // String swimTeam = '';
  // Map<String, String> bestTimes = {
  //   '50 yard Freestyle': '',
  //   '100 yard Freestyle': '',
  //   '200 yard Freestyle': '',
  //   '100 yard Butterfly': '',
  //   '200 yard Butterfly': '',
  // };
  // String gender = '';

  final user = FirebaseAuth.instance.currentUser;
  String? userName;
  int age = 0;
  String? swimTeam;

  String? userUID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // children: [SizedBox(height: 20.0), if (user != null) {}],
        ),
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ListView(
      //     children: <Widget>[
      //       TextField(
      //         decoration: const InputDecoration(labelText: 'Name'),
      //         onChanged: (value) {
      //           setState(() {
      //             name = value;
      //           });
      //         },
      //       ),
      //       const SizedBox(height: 10.0),
      //       TextField(
      //         decoration: const InputDecoration(labelText: 'Age'),
      //         onChanged: (value) {
      //           setState(() {
      //             age = int.parse(value);
      //           });
      //         },
      //         keyboardType: TextInputType.number,
      //       ),
      //       const SizedBox(height: 10.0),
      //       TextField(
      //         decoration: const InputDecoration(labelText: 'Swim Team'),
      //         onChanged: (value) {
      //           setState(() {
      //             swimTeam = value;
      //           });
      //         },
      //       ),
      //     ]
      //   )
      // ),
    );
  }
}
