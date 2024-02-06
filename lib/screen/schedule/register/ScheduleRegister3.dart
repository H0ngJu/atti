// 피그마 '일정 등록하기 3' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/controller/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/screen/schedule/register/ScheduleRegister4.dart';

class ScheduleRegister3 extends StatefulWidget {
  const ScheduleRegister3({super.key});

  @override
  State<ScheduleRegister3> createState() => _ScheduleRegister3State();
}

class _ScheduleRegister3State extends State<ScheduleRegister3> {
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
                    description: '일정 장소를 입력해주세요',
                    totalStep: 6,
                    currentStep: 3,
                  ),
                  SizedBox(height: 40),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        scheduleController.location.value = value;
                        //print(scheduleController.name.value);
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: '예정된 장소가 어디인가요?',
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

          NextButton(next: ScheduleRegister4(), content: '다음', isEnabled: scheduleController.location.isNotEmpty,),
        ]),
      ),
    );
  }
}
