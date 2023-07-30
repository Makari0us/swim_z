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
  final picker = ImagePicker();
  File? _profileImage;
  bool _isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile Page'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile Page'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
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
                    onTap: () => _pickImage(),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider<Object>?
                          : NetworkImage(user!.profilePictureUrl ??
                              'assets/images/default_profile_image.png'),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoColumn('Name', '${user!.name}'),
                      SizedBox(width: 50.0),
                      _buildInfoColumn('Age', '${user.age ?? "N/A"}'),
                      SizedBox(width: 50.0),
                      _buildInfoColumn(
                          'Swim Team', '${user.swimTeam ?? "N/A"}'),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            user: user,
                          ),
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoColumn(String title, String value) {
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
          value,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _isUploadingImage = true;
      });

      final imageFile = File(pickedImage.path);

      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Profile_Images')
          .child(widget.userID);

      try {
        await storageRef.putFile(imageFile);
        final downloadURL = await storageRef.getDownloadURL();

        final userRef =
            FirebaseFirestore.instance.collection('Users').doc(widget.userID);

        await userRef.update({
          'Profile Picture': downloadURL,
        });

        setState(() {
          _profileImage = imageFile;
          _isUploadingImage = false;
        });
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          _isUploadingImage = false;
        });
      }
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
