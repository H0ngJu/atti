import 'package:flutter/material.dart';

class ChatComplete extends StatelessWidget {
  const ChatComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF5DB),
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.07,
              left: 16,
              right: 16),
          child: Column(
            children: [
              Container(
                child: Text(
                  '\'돌잔치\'회상 대화가 저장되었어요!',
                  style: TextStyle(fontSize: 40, color: Color(0xffA38130)),
                ),
              ),
              Image.asset('lib/assets/Atti/ChatDone.png',
                  width: MediaQuery.of(context).size.width * 0.85),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(
                        '내 기억으로 돌아가기',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
