import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _resultsController = TextEditingController();
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

  void _saveEntry() async {
    try {
      _getCurrentUser();
      final collectionReference = FirebaseFirestore.instance
          .collection("Users")
          .doc(_currentUser.uid)
          .collection("Journal Entries");

      await collectionReference.add({
        'Date': _dateController.text.trim(),
        'Location': _locationController.text.trim(),
        'Details': _detailsController.text.trim(),
        'Result': _resultsController.text.trim(),
      });

      // Clear input fields after saving
      _dateController.clear();
      _locationController.clear();
      _detailsController.clear();
      _resultsController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Journal Entry saved!"),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Journal Entry failed to save. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                hintText: 'Date',
              ),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Location',
              ),
            ),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                hintText: 'Details',
              ),
            ),
            TextField(
              controller: _resultsController,
              decoration: InputDecoration(
                hintText: 'Results',
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
