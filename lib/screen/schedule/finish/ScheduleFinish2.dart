// 피그마 '일정 완료하기 2' 화면
import 'package:atti/screen/schedule/finish/RegisterNo.dart';
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';


class ScheduleFinish2 extends StatelessWidget {
  const ScheduleFinish2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Column(
            children: [
              DetailPageTitle(
                title: '일정 완료하기',
                description: '\'마을회관 방문\'을 \n내 기억으로 남길까요?',
                totalStep: 0,
                currentStep: 0,
              ),
              SizedBox(height: 80,),
              Container(
                //margin: EdgeInsets.only(left: 30),
                child: Image.asset('lib/assets/images/hurrayatti.png',
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          )),
          NextButton(next: MemoryRegister1(), content: '네, 남깁니다', isEnabled: true,),
          NextButton(next: RegisterNo(), content: '아니요, 남기지 않습니다', isEnabled: true,),
        ],
      )
    );
  }
}
