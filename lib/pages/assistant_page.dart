import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  TextEditingController _inputController = TextEditingController();
  List<String> _chatHistory = [];

  Future<String> _getChatResponse(String input) async {
    final apiKey = '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';
    final model = 'gpt-3.5-turbo-0613';
    final apiEndpoint = 'https://api.openai.com//v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'input': input,
        'model': model,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['output'];
    } else {
      print('Reponse Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load response');
    }
  }

  void _sendMessage(String message) {
    setState(() {
      _chatHistory.add('You: $message');
    });

    _getChatResponse(message).then((response) {
      setState(() {
        _chatHistory.add('ChatGPT: $response');
      });
    });

    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(_chatHistory[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration:
                        InputDecoration(hintText: 'Enter your question...'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String message = _inputController.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
