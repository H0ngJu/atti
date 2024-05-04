import 'package:atti/screen/RoutineScheduleMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/notification/notification_controller.dart';
import '../../data/schedule/schedule_model.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../schedule/ScheduleMain.dart';
import '../../../data/notification/notification.dart';
import 'package:atti/data/notification/notification_controller.dart';
import 'dart:math';

// 이미지 파일 이름 목록
List<String> imageNames = [
  'EatingStar.png',
  'Napping.png',
  'ReadingBook.png',
  'Coffee.png',
  'Soccer.png',
  'Walking.png',
];

class FullScreenSchedule extends StatefulWidget {
  const FullScreenSchedule({super.key, required this.docRef});
  final String docRef;

  @override
  State<FullScreenSchedule> createState() => _FullScreenScheduleState();
}

class _FullScreenScheduleState extends State<FullScreenSchedule> {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  ScheduleModel? schedule;
  NotificationService notificationService = NotificationService();
  // 랜덤 이미지 파일 이름 선택
  Random random = Random();

  String getFormattedTime(String mode) {
    DateTime dateTime;
    if (mode == 'future') {
      dateTime = DateTime.now().add(Duration(hours: 1));
    } else {
      dateTime = schedule?.time?.toDate() ?? DateTime.now();
    }
    var hour = dateTime.hour;
    final minute = dateTime.minute;

    String timeOfDay = '오전';
    if (hour >= 12) {
      timeOfDay = '오후';
      if (hour > 12) hour -= 12;
    }
    return '$timeOfDay ${hour.toString().padLeft(2, '0')}시 ${minute.toString().padLeft(2, '0')}분';
  }

  Future<void> _fetchData() async {
    if (widget.docRef.isEmpty) {
      print("문서 참조가 비어있습니다.");
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore
          .collection('schedule')
          .doc(widget.docRef)
          .get();

      if (docSnapshot.exists) {
        schedule = ScheduleModel.fromSnapShot(docSnapshot);
        setState(() {});
      } else {
        print("해당 문서가 존재하지 않습니다.");
      }
    } catch (e) {
      print("데이터를 가져오는 중 에러가 발생했습니다: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String randomImageName = imageNames[random.nextInt(imageNames.length)];

    return Scaffold(
      backgroundColor: Color(0xffFFF7E3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.07,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/logo3.png',
                height: height * 0.04,
                fit: BoxFit.fitWidth),
          ),
          SizedBox(height: height * 0.03,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/Atti/$randomImageName',
                height: height * 0.27,
                fit: BoxFit.fitHeight),
          ),
          SizedBox(height: height * 0.03,),
          TextButton(
            onPressed: () {
            },
            child: Text(getFormattedTime('now'),
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xffA38130),
                  fontWeight: FontWeight.w500
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xffFFECB5)),
              overlayColor: MaterialStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              visualDensity: VisualDensity(vertical: -1),
            ),
          ),
          SizedBox(height: height * 0.02,),
          Container(
            child: Column(
              children: [
                SizedBox(height: height * 0.02,),
                Text('1시간 뒤 일정이 있어요',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                Text('\'${schedule?.name}\'',
                  style: TextStyle(fontSize: 28, color: Color(0xffA38130), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: height * 0.02,),
                Container(
                  width: width * 0.77,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xffA38130), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text('시간 : ${getFormattedTime('future')}', style: TextStyle(
                        fontSize: 24, color: Color(0xffA38130)
                      ),),
                      Text('장소 : ${schedule?.location ?? ''}', style: TextStyle(
                          fontSize: 24, color: Color(0xffA38130)
                      ),)
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05,),
              ],
            ),
          ),
          SizedBox(height: height * 0.02,),
          TextButton(onPressed: () {
            // 일정 본알림 예약 ㅡㅡㅡㅡㅡㅡㅡㅡㅡ
            notificationService.showDateTimeNotification(
              2,
              '일정 알림',
              '\'${schedule?.name}\'일정을(를) 진행하고 있나요?',
              schedule!.time!.toDate(),
              '/schedule2/${schedule?.reference!.id}',
            );

            // 일정 시간 1시간 뒤 알림 예약 ㅡㅡㅡㅡㅡㅡㅡㅡㅡ
            notificationService.showDateTimeNotification(
              2,
              '일정 알림',
              '\'${schedule?.name}\'일정의 기억 사진을 남길까요?',
              schedule!.time!.toDate().add(Duration(hours: 1)),
              '/schedule3/${schedule?.reference!.id}',
            );
            SystemNavigator.pop();
          },
            child: Text('알겠어요', style: TextStyle(
              color: Colors.white, fontSize: 24, ),),
            style: ButtonStyle(
              backgroundColor:  MaterialStateProperty.all(Color(0xffFFC215)),
              minimumSize: MaterialStateProperty.all(Size(width * 0.55, 40)),
            ),
          )

        ],
      ),
    );
  }
}


