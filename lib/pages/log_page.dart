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
  final TextEditingController _journalTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  //Results
  final TextEditingController _resultsController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  late User _currentUser;

  final List<String> _strokeOptions = [
    'Freestyle',
    'Butterfly',
    'Breaststroke',
    'Backstroke',
    'Individual Medley',
  ];

  final List<String> _distanceOptions = [
    '50',
    '100',
    '200',
  ];

  final List<String> _unitOptions = [
    'y',
    'm',
  ];

  String? _selectedStroke;

  String? _selectedDistance;
  String? _selectedUnit;

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

      if (!_areRequiredFieldsFilled()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please fill out all the fields before saving.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final collectionReference = FirebaseFirestore.instance
          .collection("Users")
          .doc(_currentUser.uid)
          .collection("Journal Entries");

      await collectionReference.add({
        'Journal Title': _journalTitleController.text.trim(),
        'Date': _dateController.text.trim(),
        'Location': _locationController.text.trim(),
        'Strokes': _selectedStroke,
        'Distance': '$_selectedDistance$_selectedUnit',
        'Results': _resultsController.text.trim(),
        'Goals': _goalsController.text.trim(),
      });

      // Clear input fields after saving
      _journalTitleController.clear();
      _dateController.clear();
      _locationController.clear();

      _resultsController.clear();
      _goalsController.clear();

      setState(() {
        _selectedStroke = null;
        _selectedDistance = null;
        _selectedUnit = null;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Journal entry saved!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Journal entry failed to save. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  bool _areRequiredFieldsFilled() {
    return _journalTitleController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _selectedStroke != null &&
        _selectedDistance != null &&
        _selectedUnit != null &&
        _resultsController.text.isNotEmpty &&
        _goalsController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Log Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[700],
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
                  // Rest of your code...
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
