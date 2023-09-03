import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late User _currentUser;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Journal Entries',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24, // Adjust the font size
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade50],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(_currentUser.uid)
                    .collection("Journal Entries")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorMessage();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingIndicator();
                  }

                  final data = snapshot.data;
                  if (data == null || data.docs.isEmpty) {
                    return _buildNoEntriesMessage();
                  }

                  final filteredData = data.docs.where((doc) {
                    final entryText =
                        "${doc['Journal Title']} ${doc['Date']} ${doc['Location']} ${doc['Strokes']} ${doc['Distance']} ${doc['Results']} ${doc['Goals']}";
                    return entryText
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  });

                  if (filteredData.isEmpty) {
                    return _buildNoEntriesMessage();
                  }

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final doc = filteredData.elementAt(index);
                      final title = doc['Journal Title'] as String;
                      final date = doc['Date'] as String;
                      final location = doc['Location'] as String;
                      final strokes = doc['Strokes'] as String;
                      final distance = doc['Distance'] as String;
                      final results = doc['Results'] as String;
                      final goals = doc['Goals'] as String;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 4,
                          color: Colors.white,
                          child: ExpansionTile(
                            title: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18, // Adjust font size
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600], // Change text color
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailText('Date', date),
                                    _buildDetailText('Location', location),
                                    _buildDetailText(
                                        'Strokes', strokes ?? 'N/A'),
                                    _buildDetailText('Distance', distance),
                                    _buildDetailText('Results', results),
                                    _buildDetailText('Goals', goals),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Text(
        'Error loading data...',
        style: TextStyle(
          color: Colors.red, // Change text color
          fontSize: 16, // Adjust font size
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Change color
        strokeWidth: 2, // Adjust thickness
      ),
    );
  }

  Widget _buildNoEntriesMessage() {
    return Center(
      child: Text(
        'No journal entries found.',
        style: TextStyle(
          color: Colors.grey[800], // Change text color
          fontSize: 16, // Adjust font size
        ),
      ),
    );
  }

  Widget _buildDetailText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
