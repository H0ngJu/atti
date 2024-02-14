import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];
  final TextEditingController userInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['GPT_API_KEY'];
    OpenAI.apiKey = apiKey!;
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
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
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: userInputController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
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

  void sendMessage() async {
    final message = userInputController.text.trim();
    if (message.isEmpty) return;

    addMessage('You: $message');
    userInputController.clear();

    final aiResponse = await fetchAIResponse(message);
    addMessage('ChatBot: $aiResponse');
  }

  void addMessage(String message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  Future<String> fetchAIResponse(String prompt) async {
    final completion = await OpenAI.instance.completion.create(
      model: "gpt-3.5-turbo",
      prompt: prompt,
    );

    return completion.choices[0].text.trim();
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ChatScreen(),
//     );
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final List<String> messages = [];
//   final TextEditingController userInputController = TextEditingController();
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
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(messages[index]),
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
//                     controller: userInputController,
//                     decoration: InputDecoration(hintText: 'Type a message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     sendMessage();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void sendMessage() async {
//     final message = userInputController.text.trim();
//     if (message.isEmpty) return;
//
//     addMessage('You: $message');
//     userInputController.clear();
//
//     final aiResponse = await fetchAIResponse(message);
//     addMessage('ChatBot: $aiResponse');
//   }
//
//   void addMessage(String message) {
//     setState(() {
//       messages.insert(0, message);
//     });
//   }
//
//   Future<String> fetchAIResponse(String prompt) async {
//     final apiKey = dotenv.dotenv.env['GPT_API_KEY'];
//     const apiEndpoint = 'https://api.openai.com/v1/engines/chat/completions';
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $apiKey',
//     };
//     final body = jsonEncode({
//       'messages': [
//         {'role': 'system', 'content': 'You are a helpful assistant.'},
//         {'role': 'user', 'content': prompt},
//       ],
//     });
//
//     try {
//       final response = await http.post(Uri.parse(apiEndpoint), headers: headers, body: body);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['choices'][0]['text'].trim();
//       } else {
//         print("code: ${response.statusCode}");
//         throw Exception('Failed to fetch AI response');
//       }
//     } catch (error) {
//       print("Error : $error");
//       return 'Error: $error';
//     }
//   }
// }