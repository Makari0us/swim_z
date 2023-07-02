import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  int age = 0;
  String swimTeam = '';
  Map<String, String> bestTimes = {
    '50 yard Freestyle': '',
    '100 yard Freestyle': '',
    '200 yard Freestyle': '',
    '100 yard Butterfly': '',
    '200 yard Butterfly': '',
  };
  String gender = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Age'),
              onChanged: (value) {
                setState(() {
                  age = int.parse(value);
                });
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: const InputDecoration(labelText: 'Swim Team'),
              onChanged: (value) {
                setState(() {
                  swimTeam = value;
                });
              },
            ),
          ]
        )
      ), 
    );
  }
}