import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:atti/index.dart';

import 'RoutineShceduleFinish.dart';

final ColorPallet colorPallet = Get.put(ColorPallet());
class ScheduleFinishModal extends StatelessWidget {
  const ScheduleFinishModal(
      {super.key,
        required this.time,
        required this.location,
        required this.name,
        required this.docRef});

  final String time;
  final String location;
  final String name;
  final DocumentReference docRef;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
            SizedBox(height: height * 0.02, width: width * 0.8,),
            Container(
                child: Text(
                  '\'${name}\'\n일정을 완료하셨나요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                  ),
                )),
            SizedBox(height: height * 0.3,),


            // 일정 완료 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container( // 네 버튼
                  //margin: EdgeInsets.only(bottom: 20),
                  width: width * 0.35,
                  child: TextButton(
                    onPressed: () async {
                      await ScheduleService().completeSchedule(docRef);
                      await addNotification(
                          '일정 알림',
                          '${authController.userName}님이 \'${name}\' 일정을 완료하셨어요!',
                          DateTime.now(),
                          false);
                      await addFinishNotification(
                          '일정 알림',
                          '${authController.userName}님이 \'${name}\' 일정을 완료하셨어요!',
                          DateTime.now(),
                          false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            RoutineScheduleFinish(
                              name: name,
                              category: 'schedule'
                            )),
                      );
                    },
                    child: Text(
                      '네',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(colorPallet.orange),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        )
                    ),
                  ),
                ),

                Container( // 아니요 버튼
                  //margin: EdgeInsets.only(bottom: 20),
                  width: width * 0.35,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScheduleFinish1(name: name)),
                      );
                    },
                    child: Text(
                      '아니요',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(
                        BorderSide(
                          color: Colors.black,
                          width: 1
                        )
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
