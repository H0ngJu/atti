// 피그마 '일정 완료하기 1' 화면
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/screen/schedule/finish/ScheduleFinish2.dart';

class ScheduleFinish1 extends StatelessWidget {
  const ScheduleFinish1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFEEBC),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(left: 15),
                  child: Text('\'추후 수정\'\n일정을 완료했어요!',
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w600, color: Color(0xffA38130)
                    ),),
                ),
                SizedBox(height: 20,),
                Container(
                  //margin: EdgeInsets.only(left: 50),
                  child: Image.asset('lib/assets/images/finish_atti.png',
                    width: MediaQuery.of(context).size.width * 0.85,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          NextButton(next: ScheduleFinish2(), content: '다음',isEnabled: true),
        ],
      ),
    );
  }
}
