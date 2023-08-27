import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swim_z/user.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile user;

  EditProfilePage({required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _age;
  String? _swimTeam;
  File? _profileImage;
  bool _isUploadingImage = false;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Saves Data to Firestore
                try {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget.user.id)
                      .update({
                    'Name': _name,
                    'Age': _age,
                    'Swim Team': _swimTeam,
                  });

                  // Update user's profile with new data
                  UserProfile updatedUser = UserProfile(
                    id: widget.user.id,
                    name: _name ?? widget.user.name,
                    age: _age ?? widget.user.age,
                    swimTeam: _swimTeam ?? widget.user.swimTeam,
                  );

                  Navigator.pop(context, updatedUser);
                } catch (e) {
                  print('Error updating user data: $e');
                }
              }
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              InkWell(
                onTap: () => _pickImage(),
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(widget.user.profilePictureUrl ??
                      'https://firebasestorage.googleapis.com/v0/b/swim-z.appspot.com/o/Profile_Images%2Fdefault_profile_picture.png?alt=media&token=3ee89af4-2672-4369-8634-deb09a257200'),
                ),
              ),
              SizedBox(height: 12.0),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                initialValue: widget.user.age?.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.tryParse(value!);
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                initialValue: widget.user.swimTeam,
                decoration: InputDecoration(labelText: 'Swim Team'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your swim team';
                  }
                  return null;
                },
                onSaved: (value) {
                  _swimTeam = value;
                },
              ),
            ],
          ),
        ),
      ),
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
          .child(widget.user.id);

      try {
        await storageRef.putFile(imageFile);
        final downloadURL = await storageRef.getDownloadURL();

        final userRef =
            FirebaseFirestore.instance.collection('Users').doc(widget.user.id);

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
}
