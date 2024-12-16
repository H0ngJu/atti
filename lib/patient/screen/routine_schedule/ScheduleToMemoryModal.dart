import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:atti/index.dart';

import 'RoutineShceduleFinish.dart';

final ColorPallet colorPallet = Get.put(ColorPallet());

class ScheduleToMemoryModal extends StatelessWidget {
  const ScheduleToMemoryModal(
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
                  '\'${name}\' 을\n내 기억에 남길까요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                  ),
                )),
            SizedBox(height: height * 0.3,),


            // 네 -> 기억 등록 페이지로 이동
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container( // 네 버튼
                  //margin: EdgeInsets.only(bottom: 20),
                  width: width * 0.37,
                  child: TextButton(
                    onPressed: () {
                      Get.to(MemoryRegister1());
                    },
                    child: Text(
                      '네',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(colorPallet.goldYellow),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        )
                    ),
                  ),
                ),

                // 아니요 -> 일정 완료 페이지로 이동
                Container(
                  //margin: EdgeInsets.only(bottom: 20),
                  width: width * 0.37,
                  child: TextButton(
                    onPressed: () {
                      //Navigator.pop(context); // 모달창 닫기

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
