// 피그마 '일정 등록 완료' 화면
import 'package:atti/commons/FinishScreen.dart';
import 'package:flutter/material.dart';

class ScheduleRegisterFinish extends StatelessWidget {
  const ScheduleRegisterFinish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          FinishScreen(title: '일정 등록하기', description: '손주 생일', content: '일정을 성공적으로 등록했어요!',),
          SizedBox(height: 50,),
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Image.asset('lib/assets/images/hurrayatti.png',
              width: 250,
              fit: BoxFit.fitWidth,
            ),
          ),

        ],
      ),
    );
  }
}
