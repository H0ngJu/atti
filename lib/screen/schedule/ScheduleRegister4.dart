// 피그마 '일정 등록하기 4' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/controller/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/screen/schedule/ScheduleRegisterCheck.dart';

class ScheduleRegister4 extends StatefulWidget {
  const ScheduleRegister4({super.key});

  @override
  State<ScheduleRegister4> createState() => _ScheduleRegister4State();
}

class _ScheduleRegister4State extends State<ScheduleRegister4> {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '일정 등록하기',
                  description: '일정 메모를 입력해주세요',
                  totalStep: 6,
                  currentStep: 4,
                ),
                SizedBox(height: 40),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    onChanged: (value) {
                      scheduleController.memo.value = value;
                      //print(scheduleController.name.value);
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      hintText: '추가로 기록할 내용이 있나요?',
                      hintStyle: TextStyle(fontSize: 24),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        NextButton(next: ScheduleRegisterCheck(), content: '다음', isEnabled: true,),
      ]),
    );
  }
}
