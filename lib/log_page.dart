// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final TextEditingController _detailsController = TextEditingController();

  // Details
  final TextEditingController _strokeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();

  //Results
  final TextEditingController _resultsController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

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

      await collectionReference.doc(_dateController.text).set({
        'Date': _dateController.text.trim(),
        'Location': _locationController.text.trim(),
        // 'Details': _detailsController.text.trim(),
        'Strokes': _strokeController.text.trim(),
        'Distance': _distanceController.text.trim(),

        'Results': _resultsController.text.trim(),
        'Goals': _goalsController.text.trim(),
      });

      // Clear input fields after saving
      _dateController.clear();
      _locationController.clear();
      // _detailsController.clear();
      _strokeController.clear();
      _distanceController.clear();

      _resultsController.clear();
      _goalsController.clear();

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                hintText: 'Date',
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  print(
                      pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(
                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                  print(
                      formattedDate); //formatted date output using intl package =>  2022-07-04
                  //You can format date as per your need
                  setState(() {
                    _dateController.text =
                        formattedDate; //set foratted date to TextField value.
                  });
                } else {
                  print("Date is not selected");
                }
              },
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                icon: Icon(Icons.location_pin),
                hintText: 'Location',
              ),
            ),
            SizedBox(height: 20.0),
            // TextField(
            //   controller: _detailsController,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.book_rounded),
            //     hintText: 'Details',
            //   ),
            // ),
            // Put Details Section Here (Strokes, Distance, etc.)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    'Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  TextField(
                    controller: _strokeController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.numbers_outlined,
                        color: Colors.white,
                      ),
                      hintText: 'Stroke',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _distanceController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                      ),
                      hintText: 'Distance',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Text(
                    'Results',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  TextField(
                    controller: _resultsController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      hintText: 'Results',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _goalsController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                      hintText: 'Goals',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            SizedBox(height: 20.0),
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
