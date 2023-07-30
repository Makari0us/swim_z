import 'package:flutter/material.dart';
import 'package:swim_z/user.dart';

class EditProfilePage extends StatelessWidget {
  final UserProfile user;

  EditProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Text('Edit Profile Page (TEMP)'),
      ),
    );
  }
}
