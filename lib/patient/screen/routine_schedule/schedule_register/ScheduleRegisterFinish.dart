// 피그마 '일정 등록 완료' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:intl/intl.dart';

import '../../../../commons/ScheduleBox.dart';
import '../../../../commons/colorPallet.dart';
import '../../../../data/notification/notification_controller.dart';
import '../../../../patient/screen/routine_schedule/RoutineScheduleMain.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
import '../../../../data/notification/notification.dart';
class ScheduleRegisterFinish extends StatefulWidget {
  const ScheduleRegisterFinish({super.key});

  @override
  State<ScheduleRegisterFinish> createState() => _ScheduleRegisterFinishState();
}

class _ScheduleRegisterFinishState extends State<ScheduleRegisterFinish> {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  NotificationService notificationService = NotificationService();
  final ColorPallet colorPallet = Get.put(ColorPallet());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final ScheduleController scheduleController = Get.put(ScheduleController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(left: 15),
                  child: Text('\'${scheduleController.schedule.value.name}\'\n일정을 등록했어요!',
                    style: TextStyle(
                      fontSize: 34, fontWeight: FontWeight.w600, color: Colors.black
                  ),),
                ),
                SizedBox(height: 30,),

                Container(
                  width: width * 0.85,
                  alignment: Alignment.topLeft,
                  child: Text(scheduleController.schedule.value?.time?.toDate() != null
                    ? DateFormat('yyyy년 M월 d일', 'ko_KR').format(scheduleController.schedule.value.time!.toDate())
                    : '',
                    style: TextStyle(
                      fontSize: 24, color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ScheduleBox(
                  time: scheduleController.schedule.value?.time?.toDate() != null
                      ? DateFormat('a hh:mm', 'ko_KR').format(scheduleController.schedule.value.time!.toDate())
                      : DateFormat('a hh:mm', 'ko_KR').format(DateTime.now()),
                  name: scheduleController.schedule.value.name,
                  location: scheduleController.schedule.value.location,
                  isFinished: false,
                  isEditMode: false,
                  onCompleted: () {},
                )


              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () async {
                final updatedSchedule = await scheduleController.addSchedule();
                print(authController.isPatient);
                if (authController.isPatient) {
                  print('updatedSchedule: ${updatedSchedule}');

                  // 일정 1시간 전 알림
                  notificationService.showDateTimeNotification(
                    notificationService.createUniqueId(),
                    '일정 알림',
                    '1시간 뒤 \'${updatedSchedule.name}\'을(를) 하실 시간이에요!',
                    updatedSchedule.time!.toDate().subtract(Duration(hours: 1)),
                    '/schedule1/${updatedSchedule.reference!.id}',
                  );

                  // 일정 본알림
                  await notificationService.showDateTimeNotification(
                    notificationService.createUniqueId(),
                    '일정 알림',
                    '\'${updatedSchedule.name}\'일정을(를) 진행하고 있나요?',
                    //updatedSchedule.time!.toDate(),
                    updatedSchedule.time!.toDate().subtract(Duration(minutes:58)),
                    '/schedule2/${updatedSchedule.reference!.id}',
                  );

                  // 일정 1시간 뒤 알림
                  // await notificationService.showDateTimeNotification(
                  //   notificationService.createUniqueId(),
                  //   '일정 알림',
                  //   '\'${updatedSchedule.name}\'일정의 기억 사진을 남길까요?',
                  //   updatedSchedule.time!.toDate().add(Duration(hours: 1)),
                  //   //schedule!.time!.toDate().subtract(Duration(minutes:58)),
                  //   '/schedule3/${updatedSchedule.reference!.id}',
                  // );

                }
                Get.to(RoutineScheduleMain());
              },
              child: Text('일과/일정으로 돌아가기', style: TextStyle(color: Colors.white, fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
