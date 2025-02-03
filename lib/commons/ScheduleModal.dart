import 'package:atti/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import '../data/notification/notification_controller.dart';
import '../data/schedule/schedule_service.dart';
import '../tmp/screen/schedule/finish/ScheduleFinish1.dart';
import '../tmp/screen/schedule/finish/ScheduleFinish2.dart';

class ScheduleModal extends StatelessWidget {
  const ScheduleModal(
      {super.key,
      required this.time,
      required this.location,
      required this.name,
      required this.memo,
      required this.docRef});

  final String time;
  final String location;
  final String name;
  final String? memo;
  final DocumentReference docRef;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final AuthController authController = Get.put(AuthController());

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Color(0xffB8B8B8),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            SizedBox(height: 5, width: width * 0.8,),
            Container(
                child: Text(
              name,
              style: TextStyle(fontSize: 30),
            )),
            SizedBox(height: height * 0.03,),

            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xffDDDDDD),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: width * 0.04,),
                  Text(
                    '시간',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: width * 0.04,),

                  Container(
                    width: 1, // 선의 두께
                    height: 50, // 선의 높이
                    color: Color(0xffDDDDDD), // 선의 색상
                    //margin: EdgeInsets.symmetric(horizontal: 12), // 좌우 여백
                  ),

                  SizedBox(width: width * 0.05,),
                  Text(time, style: TextStyle(fontSize: 24)),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xffDDDDDD),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: width * 0.04,),
                  Text(
                    '장소',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: width * 0.04,),

                  Container(
                    width: 1, // 선의 두께
                    height: 50, // 선의 높이
                    color: Color(0xffDDDDDD), // 선의 색상
                    //margin: EdgeInsets.symmetric(horizontal: 12), // 좌우 여백
                  ),

                  SizedBox(width: width * 0.05,),
                  Text(location, style: TextStyle(fontSize: 24)),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xffDDDDDD),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: width * 0.04,),
                  Text(
                    '메모',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: width * 0.04,),

                  Container(
                    width: 1, // 선의 두께
                    height: 100, // 선의 높이
                    color: Color(0xffDDDDDD), // 선의 색상
                    //margin: EdgeInsets.symmetric(horizontal: 12), // 좌우 여백
                  ),

                  SizedBox(width: width * 0.05,),
                  Text(memo ?? '-', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),

            SizedBox(
              height: height * 0.05,
            ),

            // 일정 완료 버튼 (환자일때만 나타나게)
            // if (authController.isPatient)
            //   Container(
            //     //margin: EdgeInsets.only(bottom: 20),
            //     child: TextButton(
            //       onPressed: () async {
            //         await ScheduleService().completeSchedule(docRef);
            //         await addNotification(
            //             '일정 알림',
            //             '${authController.userName}님이 \'${name}\' 일정을 완료하셨어요!',
            //             DateTime.now(),
            //             false);
            //         await addFinishNotification(
            //             '일정 알림',
            //             '${authController.userName}님이 \'${name}\' 일정을 완료하셨어요!',
            //             DateTime.now(),
            //             false);
            //
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => ScheduleFinish1(name: name)),
            //         );
            //       },
            //       child: Text('완료했어요', style: TextStyle(color: Colors.white, fontSize: 20),),
            //       style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
            //         minimumSize: MaterialStateProperty.all(
            //             Size(MediaQuery.of(context).size.width * 0.8, 50)),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
