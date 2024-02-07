// 피그마 '일정 등록하기 5 - 입력한 일정 확인' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:atti/data/schedule/controller/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/ScheduleBox.dart';

import 'package:atti/screen/schedule/register/ScheduleRegisterFinish.dart';

class ScheduleRegisterCheck extends StatefulWidget {
  const ScheduleRegisterCheck({super.key});

  @override
  State<ScheduleRegisterCheck> createState() => _ScheduleRegisterCheckState();
}

class _ScheduleRegisterCheckState extends State<ScheduleRegisterCheck> {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    // print('일정 이름: ${scheduleController.name.value}');
    // print('일정 날짜: ${scheduleController.date.value}');
    // print('일정 시간: ${scheduleController.time.value}');
    // print('일정 장소: ${scheduleController.location.value}');
    // print('일정 메모: ${scheduleController.memo.value}');
    String formattedDate = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(scheduleController.date.value);

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '일정 등록하기',
                  description: '이대로 등록할까요?',
                  totalStep: 5,
                  currentStep: 5,
                ),
                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(formattedDate, style: TextStyle(fontSize: 24,),)
                ),
                SizedBox(height: 5,),
                ScheduleBox(
                  time: scheduleController.time.value,
                  name: scheduleController.name.value,
                  location: scheduleController.location.value,
                ),
                SizedBox(height: 10,),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xffFFE9B3)),
                          overlayColor: MaterialStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                        ),
                        child: Text('일정 메모',
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal,),),
                      ),
                      SizedBox(width: 10),
                      Text(scheduleController.memo.value, style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: TextButton(
            onPressed: () {
              addScheduleToFirestore(scheduleController);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScheduleRegisterFinish()),
              );
            },
            child: Text('등록하기', style: TextStyle(color: Colors.black, fontSize: 20),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey),
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.9, 50)),
            ),
          ),
        ),
      ]),
    );
  }
}
