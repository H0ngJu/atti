// 피그마 '일정 등록하기 1 - 일정 이름' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/screen/schedule/register/ScheduleRegister2.dart';


class ScheduleRegister1 extends StatefulWidget {
  const ScheduleRegister1({super.key});

  @override
  State<ScheduleRegister1> createState() => _ScheduleRegister1State();
}

class _ScheduleRegister1State extends State<ScheduleRegister1> {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailPageTitle(
                    title: '일정 등록하기',
                    description: '일정 이름을 입력해주세요',
                    totalStep: 5,
                    currentStep: 1,
                  ),
                  SizedBox(height: 20),
        
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        scheduleController.name.value = value;
                        //print(scheduleController.name.value);
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: '예정된 일정이 무엇인가요?',
                        hintStyle: TextStyle(fontSize: 24, color: Color(0xffA38130)),
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFE9B3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(15), // 위아래 여백 조절
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        
         NextButton(next: ScheduleRegister2(), content: '다음', isEnabled: scheduleController.name.isNotEmpty,),
        ]),
      ),
    );
  }
}

