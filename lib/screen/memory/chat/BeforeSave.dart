import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/screen/memory/chat/Chat.dart';
import 'package:atti/screen/memory/chat/ChatComplete.dart';
import 'package:atti/screen/memory/gallery/MainGallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeforeSave extends StatelessWidget {
  const BeforeSave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    '2010년대',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '\'돌잔치\' 기억',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetImage('lib/assets/Atti/Normal.png'),
                            width: MediaQuery.of(context).size.width * 0.65,
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

              NextButton(isEnabled: true,next: ChatComplete(), content: '네, 저장합니다',),
              NextButton(isEnabled: true ,next: MainGallery(), content: '아니오, 저장하지 않습니다',)
            ],
          ),
        ),
      ),
    );
    ;
  }
}
