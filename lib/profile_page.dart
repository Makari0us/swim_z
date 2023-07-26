// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'user.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  ProfilePage({required this.userID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final picker = ImagePicker();
  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
        // Save the new image to Firebase Storage
      });
    }
  }

  Future<UserProfile> _fetchUserData() async {
    final userRef =
        FirebaseFirestore.instance.collection('Users').doc(widget.userID);
    final userData = await userRef.get();

    if (userData.exists) {
      return UserProfile.fromMap(
          userData.data() as Map<String, dynamic>, userData.id);
    } else {
      return UserProfile(
          id: widget.userID, name: '', age: null, swimTeam: null);
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
                  InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage(
                                  'assets/images/default_profile_image.png')
                              as ImageProvider<Object>,
                    ),
                  ),
                  SizedBox(height: 30.0),
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
