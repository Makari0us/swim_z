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
  String? _bio;
  File? _profileImage;
  bool _isUploadingImage = false;
  bool _isProfileImageChanged = false;
  final picker = ImagePicker();
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Unsaved Changes"),
              content:
                  Text("You have unsaved changes. Do you wish to proceed?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Stay on the page
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Pop the page
                  },
                  child: Text("Yes"),
                ),
              ],
            ),
          );
        }
        return true; // Allow popping the page if no unsaved changes
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
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
          backgroundColor: Colors.blue[600],
          actions: [
            IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (_isProfileImageChanged) {
                    await _uploadProfileImage();
                  }

                  try {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.user.id)
                        .update({
                      'Name': _name,
                      'Age': _age,
                      'Swim Team': _swimTeam,
                      'Bio': _bio,
                      if (_isProfileImageChanged)
                        'Profile Picture': _profileImage,
                    });

                    UserProfile updatedUser = UserProfile(
                      id: widget.user.id,
                      name: _name ?? widget.user.name,
                      age: _age ?? widget.user.age,
                      swimTeam: _swimTeam ?? widget.user.swimTeam,
                      bio: _bio ?? '',
                      profilePictureUrl: _isProfileImageChanged
                          ? _profileImage.toString()
                          : widget.user.profilePictureUrl,
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.shade800,
                        width: 3.0,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _pickImage(),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : NetworkImage(widget.user.profilePictureUrl ??
                                'https://firebasestorage.googleapis.com/v0/b/swim-z.appspot.com/o/Profile_Images%2Fdefault_profile_picture.png?alt=media&token=3ee89af4-2672-4369-8634-deb09a257200'),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  TextFormField(
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      // labelText: 'Name',
                      hintText: 'Name',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: widget.user.age?.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      // labelText: 'Age',
                      hintText: 'Age',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                      ),
                    ),
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: widget.user.swimTeam,
                    decoration: InputDecoration(
                      // labelText: 'Swim Team',
                      hintText: 'Swim Team',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.pool,
                      ),
                    ),
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: widget.user.bio,
                    maxLines: 3,
                    decoration: InputDecoration(
                      // labelText: 'Bio',
                      hintText: 'Bio',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.info,
                      ),
                    ),
                    onSaved: (value) {
                      _bio = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage != null) {
      setState(() {
        _isUploadingImage = true;
      });

      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Profile_Images')
          .child(widget.user.id);

      try {
        await storageRef.putFile(_profileImage!);
        final downloadURL = await storageRef.getDownloadURL();

        final userRef =
            FirebaseFirestore.instance.collection('Users').doc(widget.user.id);

        await userRef.update({
          'Profile Picture': downloadURL,
        });

        setState(() {
          _isUploadingImage = false;
          _isProfileImageChanged = false; // Reset profile image change flag
        });
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _isProfileImageChanged = true; // Set the flag when image is changed
        _profileImage = File(pickedImage.path);
        _hasUnsavedChanges = true; // Set the flag for unsaved changes
      });
    }
  }
}
