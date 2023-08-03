// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late User _currentUser;

  void _getCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Journal'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(_currentUser.uid)
              .collection("Journal Entries")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error loading data...'),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final data = snapshot.data;
            if (data == null || data.docs.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text('No log entries found.'),
                ),
              );
            }

            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                final doc = data.docs[index];
                final date = doc['Date'] as String;
                final location = doc['Location'] as String;
                final strokes = doc['Strokes'] as String;
                final distance = doc['Distance'] as String;
                final results = doc['Results'] as String;
                final goals = doc['Goals'] as String;

                // return ListTile(
                //   title: Text(date),
                //   subtitle: Text(
                //       'Location: $location\nStrokes: $strokes\nDistance: $distance\nResults: $results\nGoals: $goals'),
                // );

                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    child: ExpansionTile(
                      title: Text(date),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.0),
                              Text('Location: $location'),
                              SizedBox(height: 10.0),
                              Text('Strokes: $strokes'),
                              SizedBox(height: 10.0),
                              Text('Distance: $distance'),
                              SizedBox(height: 10.0),
                              Text('Results: $results'),
                              SizedBox(height: 10.0),
                              Text('Goals: $goals'),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
