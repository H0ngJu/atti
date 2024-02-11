// 피그마 '일정 등록 완료' 화면
import 'package:atti/commons/FinishScreen.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/screen/HomePatient.dart';

class ScheduleRegisterFinish extends StatelessWidget {
  const ScheduleRegisterFinish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFEEBC),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                FinishScreen(content: '일정을 성공적으로\n등록했어요!'),
                SizedBox(height: 50,),
                Container(
                  //margin: EdgeInsets.only(left: 50),
                  child: Image.asset('lib/assets/images/hurrayatti.png',
                    width: 230,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          NextButton(next: HomePatient(), content: '일정으로 돌아가기', isEnabled: true)
        ],
      ),
    );
  }
}
