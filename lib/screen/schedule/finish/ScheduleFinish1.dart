// 피그마 '일정 완료하기 1' 화면
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/ScheduleBox.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/screen/schedule/finish/ScheduleFinish2.dart';

class ScheduleFinish1 extends StatelessWidget {
  const ScheduleFinish1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              //width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  DetailPageTitle(
                    title: '일정 완료하기',
                    description: '\'마을회관 방문\' 일정을 \n완료하셨나요?',
                    totalStep: 0,
                    currentStep: 0,
                  ),
                  SizedBox(height: 30,),
                  ScheduleBox(time: '오후 1:20', name: '마을회관 방문', location: '우암 3동 마을회관',),

                ],
              ),
            ),
          ),
          NextButton(next: ScheduleFinish2(), content: '네', isEnabled: true,),
          NextButton(next: ScheduleFinish2(), content: '아니요', isEnabled: true,),
        ],
      ),
    );
  }
}
