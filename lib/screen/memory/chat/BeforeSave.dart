import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/data/memory/chatController.dart';
import 'package:atti/screen/memory/chat/Chat.dart';
import 'package:atti/screen/memory/chat/ChatComplete.dart';
import 'package:atti/screen/memory/gallery/MainGallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/memory/memory_note_model.dart';

class BeforeSave extends StatelessWidget {
  final MemoryNoteModel memory;
  final String chat;
  const BeforeSave({Key? key, required this.memory, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatController chatController = ChatController();

    return Scaffold(
      appBar: SimpleAppBar(title: '아띠와의 회상 대화'),
      body: SingleChildScrollView(
        child: Container(
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
                    '${memory.era}년대',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '\'${memory.imgTitle}\' 기억',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${chat}\n${chat.runtimeType}\n${memory.reference?.id}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage('lib/assets/Atti/Normal.png'),
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffFFF5DB).withOpacity(0.8),
                            ),
                            child: Text(
                              '방금 아띠와 나눈 대화를 저장할까요?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30, color: Color(0xffA38130)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05),
                  Center(
                      child : Container(child: Text('대화를 나누어 즐거웠어요!', style: TextStyle(fontSize: 24),),)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    if (memory.reference?.path != null) {
                      await chatController.updateChat(chat, memory.reference!.path);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatComplete()),
                      );
                    } else {
                      print('Error: memory.reference?.path is null');
                    }
                  },
                  child: Text('네, 저장합니다', style: TextStyle(color: Colors.white, fontSize: 20),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.9, 50)),
                  ),
                ),
              ),
              NextButton(isEnabled: true, next: MainGallery(), content: '아니오, 저장하지 않습니다',)
            ],
          ),
        ),
      ),
    );
  }
}