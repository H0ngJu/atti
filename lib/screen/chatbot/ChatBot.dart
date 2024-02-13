import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];
  final TextEditingController userInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('챗봇'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: userInputController,
                    decoration: InputDecoration(hintText: '메시지를 입력하세요...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addMessage(String sender, String message) {
    setState(() {
      messages.insert(0, '$sender: $message');
    });
  }

  Future<String> fetchAIResponse(String prompt) async {
    final apiKey = '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';
    final apiEndpoint = 'https://api.openai.com/v1/engines/davinci/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      'prompt': prompt,
      'max_tokens': 50,
    });

    try {
      final response = await http.post(Uri.parse(apiEndpoint), headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['text'];
        return aiResponse;
      } else {
        throw Exception('OpenAI API 호출 중 오류 발생');
      }
    } catch (error) {
      print('OpenAI API 호출 중 오류 발생: $error');
      return 'OpenAI API 호출 중 오류 발생';
    }
  }

  void sendMessage() async {
    final message = userInputController.text.trim();
    if (message.isEmpty) return;

    addMessage('나', message);
    userInputController.clear();

    final aiResponse = await fetchAIResponse(message);
    addMessage('챗봇', aiResponse);
  }
}