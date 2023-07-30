// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 5.0),
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
              SizedBox(height: 5.0),
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
              SizedBox(height: 10.0),
              ElevatedButton(
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
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
