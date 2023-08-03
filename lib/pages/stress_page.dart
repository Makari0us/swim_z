import 'package:flutter/material.dart';
import 'audio_page.dart';

import 'journal_page.dart';
import 'quotes_page.dart';

class StressPage extends StatefulWidget {
  const StressPage({super.key});

  @override
  State<StressPage> createState() => _StressPageState();
}

class _StressPageState extends State<StressPage> {
  Widget buildButton(String title, String imageAsset, Widget page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 100,
                color: Colors.blue,
              ),
            ),
            Positioned(
              bottom: 5.0,
              right: 15.0,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Image.asset(
                'assets/images/$imageAsset',
                height: 70.0,
                width: 70.0,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stress'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildButton('Audio', 'advice-icon.png', AudioPage()),
            buildButton('Quotes', 'advice-icon.png', QuotesPage()),
            buildButton('Journal', 'advice-icon.png', JournalPage()),
          ],
        ),
      ),
    );
  }
}
