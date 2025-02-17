// 피그마 '일정 등록하기 4 - 일정 메모' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import '../../../../commons/colorPallet.dart';
import '../../../../patient/screen/routine_schedule/schedule_register/ScheduleRegisterCheck.dart';

class ScheduleRegister4 extends StatefulWidget {
  const ScheduleRegister4({super.key});

  @override
  State<ScheduleRegister4> createState() => _ScheduleRegister4State();
}

class _ScheduleRegister4State extends State<ScheduleRegister4> {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final ColorPallet colorPallet = Get.put(ColorPallet());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const DetailPageTitle(
                    title: '일정 등록하기',
                    description: '일정 메모를 입력해주세요',
                    totalStep: 3,
                    currentStep: 3,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        scheduleController.schedule.value.memo = value;
                        //print(scheduleController.name.value);
                      },
                      cursorColor: Colors.black,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: '추가로 기록할 내용이 있나요?',
                        hintStyle: TextStyle(
                            fontSize: 24,
                            color: colorPallet.khaki,
                            fontWeight: FontWeight.w400
                        ),
                        filled: true, // 배경을 채움
                        fillColor: const Color(0xffFFF5DB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),

          const BottomNextButton(next: ScheduleRegisterCheck(), content: '다음', isEnabled: true,),
        ]),
      ),
    );
  }
}
