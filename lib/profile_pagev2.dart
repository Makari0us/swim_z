// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class ProfilePage extends StatelessWidget {
  final String userID;

  ProfilePage({required this.userID});

  Future<UserProfile> _fetchUserData() async {
    final userRef = FirebaseFirestore.instance.collection('Users').doc(userID);
    final userData = await userRef.get();

    if (userData.exists) {
      return UserProfile.fromMap(
          userData.data() as Map<String, dynamic>, userData.id);
    } else {
      return UserProfile(id: userID, name: '', age: null, swimTeam: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: $snapshot.error}');
        } else {
          final user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile Page'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('${user!.name}',
                              style: TextStyle(
                                fontSize: 18.0,
                              )),
                        ],
                      ),
                      SizedBox(width: 50.0),
                      Column(
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('${user!.age.toString()}',
                              style: TextStyle(
                                fontSize: 18.0,
                              )),
                        ],
                      ),
                      SizedBox(width: 50.0),
                      Column(
                        children: [
                          Text(
                            'Swim Team',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '${user!.swimTeam}',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
