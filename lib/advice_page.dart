import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key});

  @override
  State<AdvicePage> createState() => _AdvicePageState();

}

class _AdvicePageState extends State<AdvicePage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  void _performSearch(String query) async{
    final apiKey = "AIzaSyB7JP8CDJoYcCaGNfo1S7LHR1d3QEtj6Rk";
    final url = 'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=a6c7201c92d394395&q=$query';
    try{
      final response = await http.get(Uri.parse(url));
      final jsonData = json.decode(response.body);

      setState(() {
        _searchResults = jsonData['results'];
      });
    } catch (error){
      print ("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advice'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Ask your question',
                border: OutlineInputBorder(),
                prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: (){_performSearch(_searchController.text);},),
              ),
            ),
          ),
          Expanded(child: ListView.builder(
           itemCount: _searchResults.length, 
           itemBuilder: (BuildContext context, int index) {
            final result = _searchResults[index];
            return Container(
              color: Colors.blue,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result['title'] ?? 'Title not available',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        result['description'] ?? 'Description not available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
            );
           },
           )),
        ],
      ),
    );
  }
}
