import 'package:atti/patient/screen/routine_schedule/RoutineScheduleMain.dart';
import 'package:flutter/material.dart';
import '../../../commons/colorPallet.dart';
import '../../../data/notification/notification_controller.dart';
import '../../../data/routine/routine_controller.dart';
import '../../../data/routine/routine_model.dart';
import '../../../data/routine/routine_service.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../data/notification/notification.dart';

import '../routine_schedule/CustomModal.dart';

class RoutineNoti extends StatefulWidget {
  const RoutineNoti({super.key, required this.docRef});

  final String docRef;

  @override
  State<RoutineNoti> createState() => _ScheduleNoti1State();
}

class _ScheduleNoti1State extends State<RoutineNoti> {
  final RoutineController routineController = Get.put(RoutineController());
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  RoutineModel? routine;
  NotificationService notificationService = NotificationService();

  final ColorPallet colorPallet = Get.put(ColorPallet());

  String formatTime(List<int> time) {
    String period = "오전";
    int hour = time[0];
    int minute = time[1];

    if (hour >= 12) {
      period = "오후";
      if (hour > 12) hour -= 12;
    }
    String formattedTime = "$period $hour시 $minute분";
    return formattedTime;
  }

  // 현재 시간을 '오후 08:30' 형식으로 출력
  String getCurrentFormattedTime() {
    DateTime now = DateTime.now();
    String period = now.hour >= 12 ? "오후" : "오전";
    int hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    String minute = now.minute.toString().padLeft(2, '0');
    return "$period ${hour.toString().padLeft(2, '0')}:$minute";
  }

  Future<void> _fetchData() async {
    if (widget.docRef.isEmpty) {
      print("문서 참조가 비어있습니다.");
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore
          .collection('routine')
          .doc(widget.docRef)
          .get();

      if (docSnapshot.exists) {
        routine = RoutineModel.fromSnapShot(docSnapshot);
        setState(() {});
        print(routine!.name);
        print(routine!.time);

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

    return Scaffold(
      backgroundColor: const Color(0xffFFF7E3),
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
              height: width * 0.09,
            ),
            // 현재 시간
            Text(
              formatTime(routine?.time ?? [0,0]),
              style: const TextStyle(
                fontSize: 40,
                //height: 1.0
              ),
            ),
            Text(
              DateFormat('MM월 dd일 EEEE', 'ko').format(DateTime.now()),
              style: const TextStyle(
                  fontSize: 24,
                  height: 1.0
              ),
            ),
            SizedBox(height: width * 0.06,),

            // 아띠 말고 사진으로
            Container(
              alignment: Alignment.center,
              width: width * 0.65,
              height: width * 0.65,
              child: Container(
                child: ClipOval(
                  child: routine != null && routine!.img != null
                      ? Image.network(
                    routine!.img!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )
                      : Container(),
                ),
              ),
            ),

            SizedBox(height: width * 0.015,),
            Container(
              child: Column(
                children: [
                  SizedBox(height: height * 0.02,),
                  const Text(
                    '지금',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, height: 1.2),
                  ),
                  SizedBox(width: width * 0.06,),
                  Text(
                    '\'${routine?.name}\'',
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: width * 0.05,
                  ),
                ],
              ),
            ),
            SizedBox(height: width * 0.04,),
            SizedBox(
              width: width * 0.52,
              child: TextButton(
                onPressed: () {
                  // 일과 완료 모달창
                  showDialog(
                    context: context,
                    builder: (_) => CustomModal(
                      title: "'${routine!.name}'\n일과를 완료하셨나요?",
                      yesButtonColor: colorPallet.orange,

                      onYesPressed: () async {
                        await RoutineService().completeRoutine(routine!.reference!, DateTime.now());
                        await addNotification(
                            '하루 일과 알림',
                            '${authController.userName}님이 \'${routine!.name}\' 일과를 완료하셨어요!',
                            DateTime.now(),
                            false);
                        // widget.onCompleted(); // 콜백 함수 호출

                        Get.to(const RoutineScheduleMain());
                      },

                      onNoPressed: () {
                        //Navigator.pop(context);
                        Get.to(const RoutineScheduleMain());
                      },
                    ),
                  );

                  //SystemNavigator.pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(colorPallet.orange),
                  minimumSize: WidgetStateProperty.all(Size(width * 0.55, 40)),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.only(top: 7, bottom: 9), // 위아래 패딩 추가
                  ),
                ),
                child: const Text(
                  '완료했어요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: width * 0.10,),
            Center(
              child: SizedBox(
                width: width * 0.13,
                height: width * 0.13,
                child: TextButton(
                  onPressed: () {
                    Get.to(const RoutineScheduleMain());
                  },
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                          const CircleBorder(
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
                  child: const Icon(
                      Icons.close,
                      color: Colors.black
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
