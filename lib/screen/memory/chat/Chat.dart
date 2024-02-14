import 'package:atti/commons/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: '아띠와 회상 대화'),
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 열을 위에서부터 시작하도록 정렬
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
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
                  ]),
              Row(
                // 이미지를 중앙 정렬하기 위한 Row 위젯
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                children: [
                  Image(
                      image: AssetImage('lib/assets/Atti/Normal.png'),
                      width: 320),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              VoiceToTextDemo()
            ],
          ),
        ));
  }
}

class VoiceToTextDemo extends StatefulWidget {
  @override
  _VoiceToTextDemoState createState() => _VoiceToTextDemoState();
}

class _VoiceToTextDemoState extends State<VoiceToTextDemo> {
  final stt.SpeechToText _speech = stt.SpeechToText(); // stt 변수 선언 및 초기화
  bool _isListening = false;
  String _text = '';


  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _isListening ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text Demo'),
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _toggleListening,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
            SizedBox(height: 20),
            Text(
              _text,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _speech.listen(
            onResult: (result) => setState(() {
              _text = result.recognizedWords;
            }),
          );
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }
}
