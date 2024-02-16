// 피그마 '일정 등록하기 5 - 입력한 일정 확인' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
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
    DateTime? dateTime = scheduleController.schedule.value.time?.toDate();
    String formattedDate = dateTime != null ? DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(dateTime) : '';
    String formattedTime = dateTime != null ? DateFormat('HH시 mm분', 'ko_KR').format(dateTime) : '';

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '일정 등록하기',
                  description: '이대로 등록할까요?',
                  totalStep: 0,
                  currentStep: 0,
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color(0xffFFF5DB)),
                          overlayColor: MaterialStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                        ),
                        child: Text(formattedDate,
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal,),),
                      ),
                      SizedBox(),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                ScheduleBox(
                  time: formattedTime,
                  name: scheduleController.schedule.value.name,
                  location: scheduleController.schedule.value.location,
                ),
                SizedBox(height: 20,),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('일정 메모',
                        style: TextStyle(color: Color(0xffA38130), fontSize: 20, fontWeight: FontWeight.normal,)),
                      SizedBox(width: 10),
                      //Text(scheduleController.memo.value, style: TextStyle(fontSize: 20),),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xffFFF5DB)),
                            overlayColor: MaterialStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(scheduleController.schedule.value.memo ?? '',
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal,),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
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
              scheduleController.tmpScheduleName.value = scheduleController.schedule.value.name!;
              scheduleController.addSchedule();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScheduleRegisterFinish()),
              );
            },
            child: Text('등록하기', style: TextStyle(color: Colors.white, fontSize: 20),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.9, 50)),
            ),
          ),
        ),
      ]),
    );
  }
}
