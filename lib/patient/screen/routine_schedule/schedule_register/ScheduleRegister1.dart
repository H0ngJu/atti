// 피그마 '일정 등록하기 1 - 일정 이름' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/patient/screen/routine_schedule/schedule_register/ScheduleRegister2.dart';

import '../../../../commons/RegisterTextField.dart';
import '../../../../commons/colorPallet.dart';


class ScheduleRegister1 extends StatefulWidget {
  const ScheduleRegister1({super.key});

  @override
  State<ScheduleRegister1> createState() => _ScheduleRegister1State();
}

class _ScheduleRegister1State extends State<ScheduleRegister1> {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final ColorPallet colorPallet = Get.put(ColorPallet());

  @override
  Widget build(BuildContext context) {
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
                    description: '일정 이름을 입력해주세요',
                    totalStep: 3,
                    currentStep: 1,
                  ),
                  const SizedBox(height: 15),

                  RegisterTextField(
                    hintText: '어떤 일정인가요?',
                    onChanged: (value) {
                      scheduleController.schedule.value.name = value;
                    },
                  )
                ],
              ),
            ),
          ),
        
         BottomNextButton(next: const ScheduleRegister2(), content: '다음', isEnabled: scheduleController.schedule.value.name != null,),
        ]),
      ),
    );
  }
}

