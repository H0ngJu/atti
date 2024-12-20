// 피그마 '일정 등록하기 3 - 일정 장소' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/tmp/screen/schedule/register/ScheduleRegister4.dart';

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
                    totalStep: 4,
                    currentStep: 3,
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        scheduleController.schedule.value.location = value;
                        //print(scheduleController.name.value);
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: '예정된 장소가 어디인가요?',
                        hintStyle: TextStyle(fontSize: 24, color: Color(0xffA38130)),
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFF5DB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          BottomNextButton(next: ScheduleRegister4(), content: '다음', isEnabled: scheduleController.schedule.value.location != null,),
        ]),
      ),
    );
  }
}
