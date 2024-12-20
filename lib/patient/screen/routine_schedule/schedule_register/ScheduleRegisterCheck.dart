// 피그마 '일정 등록하기 5 - 입력한 일정 확인' 화면
import 'package:atti/data/notification/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/ScheduleBox.dart';
import '../../../../commons/YesNoActionButtons.dart';
import '../../../../commons/colorPallet.dart';
import '../../../../data/notification/notification.dart';
import '../../../../patient/screen/routine_schedule/schedule_register/ScheduleRegister1.dart';
import '../../../../patient/screen/routine_schedule/schedule_register/ScheduleRegisterFinish.dart';

class ScheduleRegisterCheck extends StatefulWidget {
  const ScheduleRegisterCheck({super.key});

  @override
  State<ScheduleRegisterCheck> createState() => _ScheduleRegisterCheckState();
}

class _ScheduleRegisterCheckState extends State<ScheduleRegisterCheck> {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  NotificationService notificationService = NotificationService();
  final ColorPallet colorPallet = Get.put(ColorPallet());

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime = scheduleController.schedule.value.time?.toDate();
    String formattedDate = dateTime != null ? DateFormat('yyyy년 M월 d일', 'ko_KR').format(dateTime) : '';
    String formattedTime = dateTime != null ? DateFormat('a h시 mm분', 'ko_KR').format(dateTime) : '';

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '일정 등록하기',
                  description: '다음과 같이 등록할까요?',
                  totalStep: 0,
                  currentStep: 0,
                ),
                SizedBox(height: 20),

                //SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 1,),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (scheduleController.schedule.value.time != null)
                        Text('${formattedDate} ${formattedTime}',
                          style: TextStyle(
                              fontSize: 22
                          ),
                        ),
                      if (scheduleController.schedule.value.name != null)
                        Text(scheduleController.schedule.value.name!,
                          style: TextStyle(
                              fontSize:28,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      SizedBox(height: 15,),

                      Row(
                        children: [
                          Text('장소', style: TextStyle(fontSize: 22, color: Color(0xff737373)),),
                          SizedBox(width: 20),
                          if (scheduleController.schedule.value.location != null) Text(scheduleController.schedule.value.location!, style: TextStyle(
                              fontSize: 24,
                          ),),
                        ],
                      ),
                      Row(
                        children: [
                          Text('메모', style: TextStyle(fontSize: 22, color: Color(0xff737373)),),
                          SizedBox(width: 20),
                          Text(scheduleController.schedule.value.memo ?? '-', style: TextStyle(
                            fontSize: 24,
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),


              ],
            ),
          ),
        ),

        // Container(
        //   margin: EdgeInsets.only(bottom: 20),
        //   child: TextButton(
        //     onPressed: () async {
        //       scheduleController.tmpScheduleName.value = scheduleController.schedule.value.name!;
        //
        //       Get.to(ScheduleRegisterFinish());
        //     },
        //     child: Text('등록하기', style: TextStyle(color: Colors.white, fontSize: 20),),
        //     style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
        //       minimumSize: MaterialStateProperty.all(
        //           Size(MediaQuery.of(context).size.width * 0.9, 50)),
        //     ),
        //   ),
        // ),
        YesNoActionButtons(
          primaryText: '등록',
          secondaryText: '수정',
          onPrimaryPressed: () {
            scheduleController.tmpScheduleName.value = scheduleController.schedule.value.name!;
            Get.to(ScheduleRegisterFinish());
          },
          onSecondaryPressed: () {
            Get.to(ScheduleRegister1);
          },
        ),

      ]),
    );
  }
}
