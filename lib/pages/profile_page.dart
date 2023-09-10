// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swim_z/pages/profile_settings_page.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:swim_z/user.dart';


class ProfilePage extends StatefulWidget {
  final String userID;

  ProfilePage({required this.userID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700), 
                strokeWidth: 3, 
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 18), 
              ),
            ),
          );
        } else {
          user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              elevation: 4, 
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 24, color: Colors.black87), 
              ),
              backgroundColor: Colors.blue[700], 
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.0),
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    user!.profilePictureUrl ??
                        'https://firebasestorage.googleapis.com/v0/b/swim-z.appspot.com/o/Profile_Images%2Fdefault_profile_picture.png?alt=media&token=3ee89af4-2672-4369-8634-deb09a257200',
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoColumn('Name', '${user!.name}'),
                    SizedBox(width: 50.0),
                    _buildInfoColumn('Age', '${user!.age ?? "N/A"}'),
                    SizedBox(width: 50.0),
                    _buildInfoColumn('Swim Team', '${user!.swimTeam ?? "N/A"}'),
                  ],
                ),
                if (user!.bio!.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: 20.0), // Add SizedBox above the bio
                      _buildInfoColumn('Bio', '${user!.bio}'),
                    ],
                  ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    final updatedUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          user: user!,
                        ),
                      ),
                    );

                    if (updatedUser != null) {
                      setState(() {
                        user = updatedUser;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    if (title == 'Bio' && value.isEmpty) {
      // Don't display anything if the bio is empty
      return SizedBox.shrink();
    } else if (title == 'Bio') {
      // For the 'Bio' section, don't display the title label
      return Column(
        children: [
          Text(
            value.isNotEmpty ? value : '',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      );
    }
  }

  Future<UserProfile> _fetchUserData() async {
    final userRef =
        FirebaseFirestore.instance.collection('Users').doc(widget.userID);
    final userData = await userRef.get();

    if (userData.exists) {
      return UserProfile.fromMap(
        userData.data() as Map<String, dynamic>,
        userData.id,
      );
    } else {
      return UserProfile(
        id: widget.userID,
        name: '',
        age: null,
        swimTeam: null,
      );
    }
  }
}
