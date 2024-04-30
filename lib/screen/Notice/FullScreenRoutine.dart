import 'package:flutter/material.dart';
import '../../data/notification/notification_controller.dart';
import '../../data/routine/routine_controller.dart';
import '../../data/routine/routine_model.dart';
import '../../data/routine/routine_service.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../routine/RoutineFinish.dart';
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

class FullScreenRoutine extends StatefulWidget {
  const FullScreenRoutine({super.key, required this.docRef});
  final String docRef;

  @override
  State<FullScreenRoutine> createState() => _FullScreenRoutineState();
}

class _FullScreenRoutineState extends State<FullScreenRoutine> {
  final RoutineController routineController = Get.put(RoutineController());
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  RoutineModel? routine;
  // 랜덤 이미지 파일 이름 선택
  Random random = Random();

  String formatTime(List<int> time) {
    String period = "오전";
    int hour = time[0];
    int minute = time[1];

    if (hour >= 12) {
      period = "오후";
      if (hour > 12) hour -= 12;
    }
    String formattedTime = "$period ${hour}시 ${minute}분";
    return formattedTime;
  }

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore
          .collection('routine')
          .doc(widget.docRef)
          .get();

      if (docSnapshot.exists) {
        routine = RoutineModel.fromSnapShot(docSnapshot);
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
          SizedBox(height: height * 0.05,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/logo3.png',
            height: height * 0.04,
            fit: BoxFit.fitWidth),
          ),
          SizedBox(height: height * 0.02,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/Atti/$randomImageName',
                height: height * 0.26,
                fit: BoxFit.fitHeight),
          ),
          SizedBox(height: height * 0.03,),
          TextButton(
            onPressed: () {
            },
            child: Text(formatTime(routine?.time ?? [0,0]),
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
                //SizedBox(height: height * 0.02,),
                Text('일과를 할 시간이에요',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                Text('\'${routine?.name ?? ''}\'',
                  style: TextStyle(fontSize: 28, color: Color(0xffA38130), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: height * 0.02,),
                Container(
                  alignment: Alignment.center,
                  width: width * 0.8,
                  height: height * 0.23,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      routine?.img ?? 'https://ifh.cc/g/cjfDPm.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.04,),
                TextButton(onPressed: () async {
                  DocumentReference<Object?> documentReference = firestore.doc('routine/${widget.docRef}');
                  DateTime now = DateTime.now();
                  DateTime FormattedTime = DateTime(now.year, now.month, now.day);
                  print(FormattedTime);

                  await RoutineService().completeRoutine(documentReference, FormattedTime);
                  await addNotification(
                      '하루 일과 알림',
                      '${authController.userName}님이 \'${routine?.name ?? ''}\' 일과를 완료하셨어요!',
                      DateTime.now(),
                      false);

                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => RoutineFinish(name: '\'${routine?.name ?? ''}\'\n일과를 완료했어요!')),
                   );
                },
                    child: Text('완료했어요', style: TextStyle(
                        color: Colors.white, fontSize: 24, ),),
                    style: ButtonStyle(
                      backgroundColor:  MaterialStateProperty.all(Color(0xffFFC215)),
                      minimumSize: MaterialStateProperty.all(Size(width * 0.55, 40)),
                    ),
                ),
                SizedBox(height: height * 0.02,)

              ],
            ),
          )

        ],
      )
    );
  }
}

