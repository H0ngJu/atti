import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  const ChatBubble({Key? key}) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xffFFE9B3), borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],),
      child: Text('대화를 시작하려면 아래 마이크를 눌러주세요',
          style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
    ));
  }
}
