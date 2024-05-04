import 'package:atti/screen/HomePatient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/notification/notification_controller.dart';
import '../../data/schedule/schedule_model.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../memory/register/MemoryRegister2.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
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

class FullScreenSchedule2 extends StatefulWidget {
  const FullScreenSchedule2({super.key, required this.docRef});
  final String docRef;

  @override
  State<FullScreenSchedule2> createState() => _FullScreenSchedule2State();
}

class _FullScreenSchedule2State extends State<FullScreenSchedule2> {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  ScheduleModel? schedule;
  Random random = Random();

  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  Future<void> _fetchData() async {
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
    _fetchData();
  }

  String getFormattedTime() {
    DateTime dateTime = schedule?.time?.toDate() ?? DateTime.now();
    var hour = dateTime.hour;
    final minute = dateTime.minute;
    String timeOfDay = '오전';
    if (hour >= 12) {
      timeOfDay = '오후';
      if (hour > 12) hour -= 12;
    }
    return '$timeOfDay ${hour.toString().padLeft(2, '0')}시 ${minute.toString().padLeft(2, '0')}분';
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
            child: Text(getFormattedTime(),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.02,),
                Text('일정을 진행하고 있나요?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                //SizedBox(height: height * 0.01,),
                Text('\'${schedule?.name}\'',
                  style: TextStyle(fontSize: 28, color: Color(0xffA38130), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: height * 0.07,),

                SizedBox(
                  width: width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(onPressed: () async {
                          await ScheduleService().completeSchedule(schedule!.reference!);
                          SystemNavigator.pop();
                        }, child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('네', style: TextStyle(
                            fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal
                          ),),
                        ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // 모서리를 더 작게 조정
                              ),

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03,),
                      Expanded(
                        child: TextButton(onPressed: () {
                          SystemNavigator.pop();
                        }, child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('아니요', style: TextStyle(
                            fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal
                          ),),
                        ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xffFFECB5)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // 모서리를 더 작게 조정
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05,)
              ],
            ),
          )

        ],
      ),
    );
  }
}
