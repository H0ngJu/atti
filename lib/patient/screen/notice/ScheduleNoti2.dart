import 'package:atti/patient/screen/routine_schedule/RoutineScheduleMain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../commons/ScheduleModal.dart';
import '../../../commons/colorPallet.dart';
import '../../../data/notification/notification_controller.dart';
import '../../../data/schedule/schedule_model.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

class ScheduleNoti2 extends StatefulWidget {
  const ScheduleNoti2({super.key, required this.docRef});

  final String docRef;

  @override
  State<ScheduleNoti2> createState() => _ScheduleNoti2State();
}

class _ScheduleNoti2State extends State<ScheduleNoti2> {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  ScheduleModel? schedule;
  NotificationService notificationService = NotificationService();

  final ColorPallet colorPallet = Get.put(ColorPallet());

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
    return '$timeOfDay ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // 현재 시간을 '오후 08:30' 형식으로 출력
  String getCurrentFormattedTime() {
    DateTime now = DateTime.now();
    String period = now.hour >= 12 ? "오후" : "오전";
    int hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    String minute = now.minute.toString().padLeft(2, '0');
    return "$period ${hour.toString().padLeft(2, '0')}:${minute}";
  }

  Future<void> _fetchData() async {
    if (widget.docRef.isEmpty) {
      print("문서 참조가 비어있습니다.");
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestore.collection('schedule').doc(widget.docRef).get();

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
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
              'lib/assets/images/background_image.jpg',
              fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: width * 0.1,
            ),
            // 기억친구 아띠 로고
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                  'lib/assets/logo3.png',
                  width: width * 0.38,
                  fit: BoxFit.fitWidth),
            ),
            SizedBox(
              height: width * 0.1,
            ),
            // 현재 시간
            Text(
              getCurrentFormattedTime(),
              style: TextStyle(
                fontSize: 43,
                //height: 1.0
              ),
            ),
            Text(
              DateFormat('MM월 dd일 EEEE', 'ko').format(DateTime.now()),
              style: TextStyle(
                fontSize: 24,
                height: 1.0
              ),
            ),
            SizedBox(height: width * 0.13,),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                  'lib/assets/Atti/$randomImageName',
                  height: width * 0.48,
                  fit: BoxFit.fitHeight),
            ),
            SizedBox(height: width * 0.04,),
            Container(
              child: Column(
                children: [
                  SizedBox(height: height * 0.02,),
                  Text(
                    '지금',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\'${schedule?.name}\'',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                  // Container(
                  //   width: width * 0.77,
                  //   padding: EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.transparent,
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(color: Color(0xffA38130), width: 1),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         '시간 : ${getFormattedTime('future')}',
                  //         style:
                  //             TextStyle(fontSize: 24, color: Color(0xffA38130)),
                  //       ),
                  //       Text(
                  //         '장소 : ${schedule?.location ?? ''}',
                  //         style:
                  //             TextStyle(fontSize: 24, color: Color(0xffA38130)),
                  //       )
                  //     ],
                  //   ),
                  // ),

                ],
              ),
            ),
            SizedBox(height: width * 0.05,),

            // 문구
            Text(
              '오늘을 기억하기 위해서\n이곳에서 예쁜 사진을 찍어두면\n좋을 것 같아요',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  height: 1.2
              ),

            ),

            SizedBox(height: width * 0.13,),
            Center(
              child: SizedBox(
                width: width * 0.13,
                height: width * 0.13,
                child: TextButton(
                    onPressed: () {
                      Get.to(RoutineScheduleMain());
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black
                    ),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      CircleBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 1
                        )
                      )
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      Colors.white.withOpacity(0.5),
                    )
                  ),
                ),
              ),
            )


          ],
        ),
      ]),
    );
  }
}
