import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String speaker;
  final bool isTTSEnabled;

  //final Function(String) onTextChanged;

  const ChatBubble({Key? key, required this.message, required this.speaker, required this.isTTSEnabled})
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
    print("here : ${widget.speaker}");
  }

  // message tts 읽기
  void _speakMessage(String message) async {
    await flutterTts.speak(message);
  }

  // message 업데이트 되면 호출하여 다시 tts로 읽어줌
  @override
  void didUpdateWidget(covariant ChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != oldWidget.message && widget.speaker == "Assistant" && widget.isTTSEnabled) {
      _speakMessage(widget.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          //color: Color(0xffFFE9B3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          widget.message,
          style: TextStyle(fontSize: 24, fontFamily: 'UhBee',
          color: widget.speaker == "Assistant" ? const Color(0xffA38130) : Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
