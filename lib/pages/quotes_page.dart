import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  String _QOTD = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadQOTD();
  }

  void _loadQOTD() async {
    String data = await rootBundle.loadString('assets/files/quotes.txt');
    List<String> quotes = data.split('\n');
    int index = DateTime.now().day % quotes.length; // Daily changing the quote
    setState(() {
      _QOTD = quotes[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // Added elevation
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Quote of the Day',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 4, // Added card elevation
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                _QOTD,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black, // Changed text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
