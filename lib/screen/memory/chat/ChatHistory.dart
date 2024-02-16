import 'package:atti/commons/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message {
  final String sender;
  final String text;
  final DateTime? date;

  Message({required this.sender, required this.text, required this.date});
}

class ChatHistory extends StatelessWidget {
  final List<Message> messages = [
    Message(sender: 'I', text: '어떤 기억인가요?', date: DateTime.now().subtract(Duration(days: 3))),
    Message(sender: 'Atti', text: '손자, 돌잔치, 최새돌이 기억 키워드로 저장되었어요', date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 최세돌이 태어난지 1년이 되어 돌잔치를 했어',date: DateTime.now().subtract(Duration(days: 1))),
    Message(sender: 'Atti', text: '그렇군요! 기쁘셨겠어요!\n어떤 감정이셨나요?',date: DateTime.now()),
    Message(sender: 'I', text: '신비로운 느낌',date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 너무 귀엽지',date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 너무 귀엽지',date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 너무 귀엽지',date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 너무 귀엽지',date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 너무 귀엽지',date: DateTime.now()),
    Message(sender: 'I', text: '우리 손자 너무 귀엽지',date: DateTime.now()),
  ];

  //const ChatHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      '2010년대',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '\'돌잔치\' 기억',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatMessage(message: messages[index], messages: messages);
                  },
                ),
              ],
            ),
          ),
        ));
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
        child : Column(
      crossAxisAlignment: message.sender == 'I'
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        if (_showDate(message, messages)) // 날짜를 표시해야 하는 경우
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child : Text(
              _formatDate(message.date),
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),),
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
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.7,
              ),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: message.sender == 'I'
                    ? Color(0xffFFE9B3)
                    : Color(0xffFFF5DB),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                message.text,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ],)
    );
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