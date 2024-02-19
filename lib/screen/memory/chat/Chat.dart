import 'dart:async';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/screen/chatbot/Chatbot.dart';
import 'package:atti/screen/memory/chat/BeforeSave.dart';
import 'package:atti/screen/memory/chat/ChatBubble.dart';
import 'package:atti/screen/memory/chat/ChatHistory.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String _currentMessage = '대화를 시작하려면 마이크 버튼을 누르세요'; // 내가 한 대화
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("ko-KR");
    flutterTts.setPitch(1);
    _speakMessage(_currentMessage); // Speak initial message
    //_startTimer();
  }

  /*void _startTimer() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentMessage = 'New Message';
      });
    });
  }*/

  void _speakMessage(String message) async {
    await flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: '아띠와의 회상 대화'),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              ChatBubble(
                message: _currentMessage,
                //onTextChanged: onBubbleTextChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('lib/assets/Atti/Normal.png'),
                    width: MediaQuery.of(context).size.width * 0.65,
                  ),
                ],
              ),
              VoiceButton(
                updatedMessage: (message) {
                  setState(() {
                    _currentMessage = message;
                  });
                },
              ),


            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          child: SlideUpPanel(),
        ),
      ]),
    );
  }
}

// 대화기록, 마이크, 대화 종료 버튼
class VoiceButton extends StatefulWidget {
  final Function(String) updatedMessage;
  const VoiceButton({Key? key, required this.updatedMessage}) : super(key: key);

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  String _currentMessage = '대화를 시작하려면 마이크 버튼을 누르세요';
  final _chatbot = Chatbot();
  stt.SpeechToText _speech = stt.SpeechToText();
  String _spokenText = '버튼을 누르고 음성을 입력';
  bool _isListening = false;
  int _staticTimeout = 2; // 정적 상태 타임아웃 (2초)
  int _elapsedTime = 0;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission(); // 페이지가 처음 로딩될 때 권한 요청
  }

  void _requestMicrophonePermission() async {
    // 마이크 권한 요청
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      // 사용자가 권한을 거부한 경우 처리
      print('마이크 권한이 거부되었습니다.');
    } else if (status.isPermanentlyDenied) {
      // 사용자가 권한을 영구적으로 거부한 경우 처리
      print('마이크 권한이 영구적으로 거부되었습니다.');
      await openAppSettings(); // 앱 설정으로 이동, 직접 권한을 설정
    }
  }

// 음성을 인식하고 API에 전달하여 응답 받기
  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {},
      onError: (error) {},
    );

    if (available) {
      _speech.listen(
        onResult: (result) async {
          setState(() {
            _spokenText = result.recognizedWords;
          });
          String message = result.recognizedWords ?? "";
          print('here : $message');
          _appendMessage("User", message); // 사용자의 말을 메시지로 추가
          setState(() {
            _isListening = false;
          });
          _stopListening(); // Listening 중지

          try {
            String response = await _chatbot.getResponse(message); // Chatbot으로부터 응답 받기
            _appendMessage("Assistant", response); // 챗봇 응답을 메시지로 추가
          } catch (e) {
            print("Error: $e");
          } finally {
            setState(() {
              _isListening = false;
            });
          }
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }


  // 메시지 추가
  void _appendMessage(String role, String message) {
    setState(() {
      _currentMessage = message;
      widget.updatedMessage(_currentMessage);
    });
  }

  void _resetStaticTimer() {
    setState(() {
      _elapsedTime = 0;
    });
  }

  void _startStaticTimer() {
    _resetStaticTimer();
    // 1초마다 정적 시간을 증가 -> 타이머 시작.
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
        if (_elapsedTime >= _staticTimeout) {
          _stopListening(); // 정적 타임아웃이 발생하면 음성 입력 중지
          timer.cancel(); // 타이머 중지
        }
      });
    });
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
      _startStaticTimer();
    }
    setState(() {
      _isListening = !_isListening; // 버튼 상태 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(ChatHistory());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFFF5DB),
                      shape: CircleBorder()),
                  child: Text('대화\n기록',
                      style: TextStyle(color: Color(0xffA38130)))),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: _isListening ? _stopListening : _toggleListening,
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isListening ? Color(0xff231FAD) : Color(0xffFFC215),
                    shape: CircleBorder()),
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.2,
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(BeforeSave());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFFF5DB),
                      shape: CircleBorder()),
                  child: Text(
                    '대화\n종료',
                    style: TextStyle(color: Color(0xffA38130)),
                  )),
            ),
          ]),

      // 얘는 임시로 말하는거 보여주려고 ..
      /*Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xffF6B818))),
          child: Text('$_spokenText',
              style: TextStyle(color: Colors.black, fontSize: 25)))*/
    ]);
  }
}

// 슬라이드 업
class SlideUpPanel extends StatefulWidget {
  const SlideUpPanel({Key? key}) : super(key: key);

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  bool _isPanelOpen = false;
  double _panelHeightClosed = 50;
  double _panelHeightOpen = 50;
  final List<String> tagList = ['아들', '손자', '돌잔치', '아들', '손자', '돌잔치'];

  Widget TagContainer(tagName) {
    return Container(
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Color(0xffFFF5DB), borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.all(10),
      child: Text(
        '$tagName',
        style: TextStyle(color: Color(0xffA38130), fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * 0.55;
    _panelHeightClosed = MediaQuery.of(context).size.height * 0.12;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPanelOpen = !_isPanelOpen;
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: _isPanelOpen ? _panelHeightOpen : _panelHeightClosed,
          decoration: BoxDecoration(
              color: Color(0xffFFE9B3),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: _isPanelOpen
              ? Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 50,
                        color: Color(0xffFFC215),
                      ),
                      Text(
                        '사진 닫기',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xffA38130)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Image.network(
                        'https://newsimg-hams.hankookilbo.com/2022/05/08/f5107e5a-7266-4132-9550-8713162df25a.jpg',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Wrap(
                          spacing: 10, // 각 행의 간격을 조절합니다.
                          children: tagList.map((tag) {
                            return TagContainer(tag);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  child: Column(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_up_rounded,
                        size: 50,
                        color: Color(0xffFFC215),
                      ),
                      Text(
                        '사진 보기',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xffA38130)),
                      )
                    ],
                  ),
                )),
    );
  }
}
