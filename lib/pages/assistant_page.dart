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
    final model = 'gpt-3.5-turbo';
    final apiEndpoint = 'https://api.openai.com/v1/chat/completions';

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
    }).catchError((error) {
      setState(() {
        _chatHistory.add('Error: $error');
      });
    });

    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final chat = _chatHistory[index];
                final label = chat.contains(':')
                    ? chat.substring(0, chat.indexOf(':') + 1)
                    : '';
                final message = chat.contains(':')
                    ? chat.substring(chat.indexOf(':') + 1)
                    : chat;

                TextStyle labelStyle = TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                );

                TextStyle messageStyle = TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                );

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: label, style: labelStyle),
                        TextSpan(text: message, style: messageStyle),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter your question...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      String message = _inputController.text;
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
