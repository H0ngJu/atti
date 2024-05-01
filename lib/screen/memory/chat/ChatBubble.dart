import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String speaker;

  //final Function(String) onTextChanged;

  const ChatBubble({Key? key, required this.message, required this.speaker})
      : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final FlutterTts flutterTts = FlutterTts();

  // 초기 설정
  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("ko-KR");
    flutterTts.setPitch(1);
    //_speakMessage(widget.message); // Speak initial message
    printSpeaker();
  }

  void printSpeaker() {
    print("here : " + widget.speaker);
  }

  // message tts 읽기
  void _speakMessage(String message) async {
    await flutterTts.speak(message);
  }

  // message 업데이트 되면 호출하여 다시 tts로 읽어줌
  @override
  void didUpdateWidget(covariant ChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != oldWidget.message && widget.speaker == "Assistant") {
      _speakMessage(widget.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 30),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          //color: Color(0xffFFE9B3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          widget.message,
          style: TextStyle(fontSize: 20, fontFamily: 'UhBee',
          color: widget.speaker == "Assistant" ? Color(0xffA38130) : Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
