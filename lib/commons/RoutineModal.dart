import 'package:atti/data/notification/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data/routine/routine_service.dart';
import '../screen/routine/RoutineFinish.dart';
import '../screen/schedule/finish/ScheduleFinish1.dart';

class RoutineModal extends StatelessWidget {
  final Function onCompleted; // 콜백 함수 추가

  const RoutineModal({
    super.key,
    required this.days,
    required this.time,
    required this.img,
    required this.name,
    required this.docRef,
    required this.date,
    required this.onCompleted,
  });

  final List<String> days;
  final List<int> time;
  final String img;
  final String name;
  final DocumentReference docRef;
  final date;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    String formattedTime = '';
    if (time != null && time.length == 2) {
      final int hour = time[0];
      final int minute = time[1];
      final bool isPM = hour >= 12; // 오후 여부 확인
      int hour12 = hour > 12 ? hour - 12 : hour;
      hour12 = hour12 == 0 ? 12 : hour12;
      formattedTime = '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 0),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close, color: Color(0xffB8B8B8),),
                  padding: EdgeInsets.zero,
                )
              ],
            ),
            // Text(generateRepeatText(days), style: TextStyle(
            //   fontSize: 24, color: Color(0xffA38130),
            // ),),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  img,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            SizedBox(height: height * 0.03,),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(formattedTime, style: TextStyle(fontSize: 24),),
                  Text(name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

            if (authController.isPatient)
              Container(
                //margin: EdgeInsets.only(bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    await RoutineService().completeRoutine(docRef, date);
                    await addNotification(
                        '하루 일과 알림',
                        '${authController.userName}님이 \'${name}\' 일과를 완료하셨어요!',
                        DateTime.now(),
                        false
                    );

                    await addFinishNotification(
                        '하루 일과 알림',
                        '${authController.userName}님이 \'${name}\' 일과를 완료하셨어요!',
                        DateTime.now(),
                        false
                    );

                    onCompleted(); // 콜백함수 추가

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoutineFinish(name: '\'${name}\'\n일과를 완료했어요!')),
                    );
                  },
                  child: Text('완료했어요', style: TextStyle(color: Colors.white, fontSize: 20),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.8, 50)),
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
