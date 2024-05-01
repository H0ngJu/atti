import 'dart:async';
import 'dart:convert';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/data/report/dangerword_controller.dart';
import 'package:atti/data/report/emotion_controller.dart';
import 'package:atti/screen/chatbot/Chatbot.dart';
import 'package:atti/screen/memory/chat/BeforeSave.dart';
import 'package:atti/screen/memory/chat/ChatBubble.dart';
import 'package:atti/screen/memory/chat/ChatHistory.dart';
import 'package:atti/screen/memory/gallery/RecollectionData.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../../chatbot/RecollectionChatbot.dart';

class ChatMessage {
  final String sender; // I or ATTI
  final String text; // 대화 내용
  final DateTime date; // 시간
  ChatMessage({
    required this.sender,
    required this.text,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  static List<Map<String, dynamic>> messagesToJson(List<ChatMessage> messages) {
    return messages.map((message) => message.toJson()).toList();
  }

  // 실제 사용할 List<Message> => Json 코드
  static String messagesToJsonString(List<ChatMessage> messages) {
    return jsonEncode(messagesToJson(messages));
  }
}

List<String> AngryMsg = [
  '화나',
  '짜증',
  '분노',
]; // 'lib/assets/Atti/Angry.png'
List<String> CalmMsg = ['편안', '그리운', '그립', '추억']; // 'lib/assets/Atti/Calm.png'
List<String> FunnyMsg = [
  '안녕',
  '신나',
  '재미',
  '재밌,' '즐거',
  '행복',
  '소중',
  '기쁘',
  '앗싸',
  '아싸',
  '좋아',
  '좋았',
]; // 'lib/assets/Atti/Funny.png'
List<String> HmmMsg = [
  '고민',
  '곰곰',
  '힘든',
  '힘들',
]; // 'lib/assets/Atti/Hmm.png'
//List<String> NormalMsg = ['그렇군요', '군요', ]; // 'lib/assets/Atti/Normal.png'
List<String> SadMsg = [
  '걱정',
  '불안',
  '슬퍼',
  '슬프',
  '슬펐',
  '위로',
  '아프',
  '아파',
  '아팠',
  '우울'
]; // 'lib/assets/Atti/Shy.png'
List<String> SurprisedMsg = [
  '놀라',
  '놀랐',
  '깜짝',
  '신기',
  '대단',
  '멋지',
  '멋진',
  '특별',
]; // 'lib/assets/Atti/Surprised.png'

class RecollectionChat extends StatefulWidget {
  final RecollectionData recollection;

  const RecollectionChat({Key? key, required this.recollection}) : super(key: key);

  @override
  State<RecollectionChat> createState() => _RecollectionChatState();
}

class _RecollectionChatState extends State<RecollectionChat> {
  String _currentMessage = '대화를 시작하려면 마이크 버튼을 누르세요'; // 내가 한 대화

  final FlutterTts flutterTts = FlutterTts();
  String _currentImage = 'lib/assets/Atti/default1.png'; // 기본 이미지 설정

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("ko-KR");
    flutterTts.setPitch(1);
    _speakMessage(_currentMessage);
  }

  void _speakMessage(String message) async {
    await flutterTts.speak(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\'${widget.recollection.title}\'기억 회상 대화'),
      ),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChatBubble(
                message: _currentMessage,
                //onTextChanged: onBubbleTextChanged,
              ),
              Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.network(
                      '${widget.recollection.img}',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  )),
              VoiceButton(
                updatedMessage: (message) {
                  setState(() {
                    _currentMessage = message;
                  });
                },
                updatedImage: (image) {
                  // 이미지 업데이트 콜백
                  setState(() {
                    _currentImage = image;
                  });
                },
                recollection: widget.recollection,),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          child: Image(
            image: AssetImage(_currentImage),
            height: MediaQuery.of(context).size.height * 0.2,
            //width: MediaQuery.of(context).size.width*0.9,
          ),
        ),
      ]),
    );
  }
}

// 대화기록, 마이크, 대화 종료 버튼
class VoiceButton extends StatefulWidget {
  final RecollectionData recollection;
  final Function(String) updatedMessage;

  //final Function(String, String) updatedMessage;
  final Function(String) updatedImage; // 이미지 업데이트 콜백 추가
  const VoiceButton(
      {Key? key,
        required this.updatedMessage,
        required this.recollection,
        required this.updatedImage})
      : super(key: key);

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  String _currentMessage = '대화를 시작하려면\n마이크 버튼을 누르세요';
  final _chatbot = RecollectionChatbot();
  stt.SpeechToText _speech = stt.SpeechToText();
  String _spokenText = '버튼을 누르고 음성을 입력';
  bool _isListening = false;
  int _staticTimeout = 5; // 정적 상태 타임아웃 (2초)
  int _elapsedTime = 0;
  late List<ChatMessage> chatMessages = []; // 대화 리스트
  late List<String> onlyUserMessages = []; // 사용자 응답만 저장
  final EmotionController emotionController = Get.put(EmotionController());
  final DangerWordController dangerWordController =
  Get.put(DangerWordController());

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission(); // 페이지가 처음 로딩될 때 권한 요청
    chatMessages.add(ChatMessage(
      sender: 'ATTI',
      text: '대화시작', //대화시작
      date: DateTime.now(),
    ));
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
          Future.delayed(Duration(seconds: 2), () async {
            if (_spokenText == message) {
              try {
                _appendMessage("User", message);
                _onUserMessage(message);

                String response = await _chatbot.getResponse(
                    message,
                    widget.recollection.img!,
                ); // Chatbot으로부터 응답 받기
                _appendMessage("Assistant", response); // 챗봇 응답을 메시지로 추가
                //_speakMessage(response);
                _onApiResponse(response);
              } catch (e) {
                print("Error: $e");
              } finally {
                setState(() {
                  _isListening = false;
                });
              }
            }
          });
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  void _appendMessage(String role, String message) {
    if (role == "Assistant") {
      setState(() {
        _currentMessage = message;
        widget.updatedMessage(_currentMessage);
      });
    }

  }

  void _resetStaticTimer() {
    setState(() {
      _elapsedTime = 0;
    });
  }

  void _startStaticTimer() {
    _resetStaticTimer();
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

  // 사용자가 말할 때 호출되는 함수
  void _onUserMessage(String message) {
    // 메시지가 이미 chatMessages 목록에 존재하는지 확인합니다.
    if (!chatMessages.any((msg) => msg.text == message)) {
      setState(() {
        // 메시지를 chatMessages 목록에 추가합니다.
        chatMessages.add(ChatMessage(
          sender: 'I',
          text: message,
          date: DateTime.now(),
        ));
        printChatMessages();
        onlyUserMessages.add(message);
      });
    }
  }

  void printChatMessages() {
    print('Printing Chat Messages:');
    for (var message in chatMessages) {
      print('Sender: ${message.sender}');
      print('Text: ${message.text}');
      print('Date: ${message.date}');
      print('-------------');
    }
  }

  void _onApiResponse(String response) {
    setState(() {
      List<List<String>> emotionLists = [
        AngryMsg,
        CalmMsg,
        FunnyMsg,
        HmmMsg,
        SadMsg,
        SurprisedMsg
      ];
      for (int i = 0; i < emotionLists.length; i++) {
        for (String emotion in emotionLists[i]) {
          if (response.contains(emotion)) {
            _showEmotionImage(i);
            return;
          }
        }
      }

      _showEmotionImage(-1);

      chatMessages.add(ChatMessage(
        sender: 'ATTI',
        text: response,
        date: DateTime.now(),
      ));
      printChatMessages();
    });
  }

  void _showEmotionImage(int index) {
    setState(() {
      switch (index) {
        case 0: // AngryMsg
          widget.updatedImage('lib/assets/Atti/worried.png');
          break;
        case 1: // CalmMsg
          widget.updatedImage('lib/assets/Atti/dafault2.png');
          break;
        case 2: // FunnyMsg
          widget.updatedImage('lib/assets/Atti/excited.png');
          break;
        case 3: // HmmMsg
          widget.updatedImage('lib/assets/Atti/happy.png');
          break;
        case 4: // SadMsg
          widget.updatedImage('lib/assets/Atti/sad.png');
          break;
        case 5: // SurprisedMsg
          widget.updatedImage('lib/assets/Atti/astonished.png');
          break;
        default:
          widget.updatedImage('lib/assets/Atti/dafault1.png'); // 기본 이미지
          break;
      }
    });
  }

  // 위험한 단어 포함 여부를 확인하고 해당 단어들을 리스트로 반환하는 함수
  List<String> getDangerWords(List<String> messages) {
    List<String> dangerWords = [
      '자살',
      '죽어야지',
      '죽으',
      '죽음',
      '죽겠다',
      '힘들',
      '외롭',
      '외로',
      '우울',
    ];
    List<String> detectedWords = [];

    for (String message in messages) {
      for (String word in dangerWords) {
        if (message.contains(word)) {
          detectedWords.add(word);
        }
      }
    }
    return detectedWords;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.2,
            margin: EdgeInsets.only(top: 20, left: 25),
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
          // 대화 버튼
          Container(
            height: MediaQuery.of(context).size.width * 0.2,
            margin: EdgeInsets.only(top: 20, right: 25),
            child: ElevatedButton(
                onPressed: () {
                  var chat = ChatMessage.messagesToJsonString(chatMessages);
                  //print(onlyUserMessages);
                  if (onlyUserMessages.isNotEmpty) {
                    _chatbot.emotionAnalysis(onlyUserMessages
                        .join(' ')); // onlyUserMessages가 비어 있지 않은 경우에만 호출

                    List<String> detectedDangerWords =
                    getDangerWords(onlyUserMessages);
                    if (detectedDangerWords.isNotEmpty) {
                      // 위험 단어가 발견된 경우
                      dangerWordController.addDangerWord(detectedDangerWords);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFFF5DB), shape: CircleBorder()),
                child: Text(
                  '대화\n종료',
                  style: TextStyle(color: Color(0xffA38130)),
                )),
          ),
          // 대화 종료 버튼
        ]);
  }
}

// 슬라이드 업 사용 X
// 슬라이드 업
class SlideUpPanel extends StatefulWidget {
  final MemoryNoteModel memory;

  const SlideUpPanel({Key? key, required this.memory}) : super(key: key);

  @override
  State<SlideUpPanel> createState() => _SlideUpPanelState();
}

class _SlideUpPanelState extends State<SlideUpPanel> {
  bool _isPanelOpen = false;
  double _panelHeightClosed = 50;
  double _panelHeightOpen = 50;
  final List<String> tagList = [];

  @override
  void initState() {
    super.initState();
    tagList.addAll(widget.memory.keyword ?? []);
  }

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
                  '${widget.memory.img}',
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
