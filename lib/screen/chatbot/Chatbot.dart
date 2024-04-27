import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

// class Chatbot {
//   Future<String> getResponse(String prompt) async {
//     print('Received prompt: $prompt');
//     await dotenv.load(fileName: '.env');
//     final String url = 'https://api.openai.com/v1/chat/completions';
//     final String apiKey = dotenv.env['GPT_API_KEY']!;
//
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $apiKey'
//     };
//
//     var body = jsonEncode({
//       'model': 'ft:gpt-3.5-turbo-1106:personal::8telQ4wq',
//       'messages': [
//         {"role": "system", "content": "너는 치매 어르신과 대화를 나누는 보이스봇 아띠야. 어르신이 화면 속의 사진에 담긴 추억을 회상하는 것을 돕는 것이 목적이야. 너의 역할은 질문에 대한 정보를 제공하는 것이 아니야. 어르신께 사진에 대해 물어봐줘. 공감하고 긍정적인 정서를 이끌어내도록 어르신께 대화를 유도해줘."},
//         {"role": "user", "content": prompt}
//       ],
//       'max_tokens': 100,
//     });
//
//     var response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: body,
//     );
//     if (response.statusCode == 200) {
//       var body = utf8.decode(response.bodyBytes);
//       var data = jsonDecode(body);
//       // var data = jsonDecode(response.body);
//       print(data);
//       if (data != null && data['choices'] != null && data['choices'][0] != null && data['choices'][0]['message'] != null) {
//         return data['choices'][0]['message']['content'].trim();
//       } else {
//         throw Exception('Unexpected response from OpenAI API ${response.statusCode} ${response.body}');
//       }
//     } else {
//       throw Exception('Failed to connect to OpenAI API ${response.statusCode} ${response.body}');
//     }
//   }
// }

class Chatbot {
  Future<String> getResponse(var prompt) async {
    print('Received prompt: $prompt');

    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }

    final model = GenerativeModel(
        model: 'gemini-1.0-pro',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
            maxOutputTokens: 70,
            temperature: 0.7,
        ),

    );
    final chat = model.startChat(history: [
      Content.text('너는 치매 어르신과 대화를 나누는 보이스봇 아띠야. 어르신이 화면 속의 사진에 담긴 추억을 회상하는 것을 돕는 것이 목적이야. 너의 역할은 질문에 대한 정보를 제공하는 것이 아니야. 어르신께 사진에 대해 물어봐줘. 공감하고 긍정적인 정서를 이끌어내도록 어르신께 대화를 유도해줘.'),
      Content.model([TextPart('어르신, 어떤 날 찍은 사진인지 기억하시나요? 이 때의 기분은 어떠셨어요?')]),
    ]);
    //var content = Content.text('How many paws are in my house?');
    var response = await chat.sendMessage(Content.text(prompt));
    print(response.text);
    return response.text!;
  }
}

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final _chatbot = Chatbot();
//   final _controller = TextEditingController();
//   final List<String> _messages = [];
//
//   Future<void> _sendMessage() async {
//     final message = _controller.text;
//     _controller.clear();
//     _appendMessage('User', message);
//     final response = await _chatbot.getResponse(message);
//     _appendMessage('Assistant', response);
//   }
//
//   void _appendMessage(String role, String message) {
//     setState(() {
//       _messages.insert(0, '$role: $message');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ChatBot'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_messages[index]),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(hintText: 'Type a message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final _chatbot = Chatbot();
//   final _controller = TextEditingController();
//   String _chatHistory = '';
//
//   Future<void> _sendMessage() async {
//     final message = _controller.text;
//     _controller.clear();
//     _appendMessage('User', message);
//     final response = await _chatbot.getResponse(message);
//     _appendMessage('Assistant', response);
//   }
//
//   void _appendMessage(String role, String message) {
//     setState(() {
//       _chatHistory += '$role: $message\n';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chatbot'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: SingleChildScrollView(
//               reverse: true,
//               child: Text(_chatHistory),
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: 'Enter message',
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: _sendMessage,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }