import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:atti/index.dart';

import 'RoutineShceduleFinish.dart';

final ColorPallet colorPallet = Get.put(ColorPallet());

class RoutineFinishModal extends StatelessWidget {
  final Function onCompleted; // 콜백 함수 추가

  const RoutineFinishModal({
    super.key,
    required this.time,
    required this.name,
    required this.docRef,
    required this.date,
    required this.onCompleted,
  });

  final List<int> time;
  final String name;
  final DocumentReference docRef;
  final date;

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
                  '\'${name}\'\n일과를 완료하셨나요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                  ),
                )),
            SizedBox(height: height * 0.3,),


            // 일과 완료 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container( // 네 버튼
                  //margin: EdgeInsets.only(bottom: 20),
                  width: width * 0.35,
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
                        MaterialPageRoute(builder: (context) =>
                            RoutineScheduleFinish(
                              name: name,
                              category: 'routine',
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
                      Navigator.pop(context);
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
