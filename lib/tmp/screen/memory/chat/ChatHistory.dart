import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/data/memory/chatController.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Message {
  final String sender;
  final String text;
  final DateTime? date;

  Message({required this.sender, required this.text, required this.date});

  // Map을 Message로 변환
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
      date: DateTime.parse(json['date']),
    );
  }

  static Future<List<Message>> getMessage(String path) async {
    String chatString = await ChatController.getChat(path);
    chatString = "[" + chatString + "]";
    List<dynamic> chatList = jsonDecode(chatString);
    List<Message> chat =
        chatList.map((json) => Message.fromJson(json)).toList();
    return chat;
  }
}

class ChatHistory extends StatelessWidget {
  final MemoryNoteModel memory;

  const ChatHistory({Key? key, required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Message>>(
      future: Message.getMessage(memory.reference!.path),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.hasData) {
          List<Message> messages = snapshot.data!;
          return Scaffold(
            appBar: SimpleAppBar(
              title: '아띠와 회상 대화 기록',
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${memory.era}년대',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          '\'${memory.imgTitle}\' 기억',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChatMessage(
                            message: messages[index], messages: messages);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Message message;
  final List<Message> messages;

  ChatMessage({required this.message, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: message.sender == 'I'
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            if (_showDate(message, messages)) // 날짜를 표시해야 하는 경우
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    _formatDate(message.date),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: message.sender == 'I'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                if (message.sender == 'Atti')
                  CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/Atti/AttiFace.png'),
                  ),
                SizedBox(width: 8),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: message.sender == 'I'
                        ? Color(0xffFFE9B3)
                        : Colors.white,
                    border: Border.all(
                        color: message.sender == 'I'
                            ? Colors.white
                            : Colors.black),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: message.sender == 'I'
                            ? Radius.circular(0)
                            : Radius.circular(15),
                    bottomLeft: message.sender == 'I' ? Radius.circular(15) : Radius.circular(0),
                    topRight: Radius.circular(15)),
                  ),
                  child: Text(
                    message.text, // 메시지 출력
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  bool _showDate(Message message, List<Message> messages) {
    if (message.date == null) return false;
    if (messages.indexOf(message) == 0) return true;
    final previousMessage = messages[messages.indexOf(message) - 1];
    return message.date!.difference(previousMessage.date!).inDays > 0;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return ''; // DateTime이 null인 경우
    return DateFormat('yyyy년 MM월 dd일').format(date);
  }
}
