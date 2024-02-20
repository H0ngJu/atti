import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/notification/notification_controller.dart';
import '../data/schedule/schedule_service.dart';
import '../screen/schedule/finish/ScheduleFinish1.dart';

class ScheduleModal extends StatelessWidget {
  const ScheduleModal({super.key, required this.time, required this.location, required this.name, required this.memo, required this.docRef});
  final String time;
  final String location;
  final String name;
  final String? memo;
  final DocumentReference docRef;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.74,
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
                  constraints: BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            Text(name, style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w500
            ),),
            SizedBox(height: 20,),
            Row(
              children: [
                Text('시간', style: TextStyle(
                    fontSize: 24
                ),),
                SizedBox(width: 25,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xffFFF5DB),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  alignment: Alignment.center,
                  child: Text(time, style: TextStyle(
                    fontSize: 24,
                  ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Text('장소', style: TextStyle(
                    fontSize: 24
                ),),
                SizedBox(width: 25,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xffFFF5DB),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  alignment: Alignment.center,
                  child: Text(location, style: TextStyle(
                    fontSize: 24,
                  ),
                  ),
                )
              ],
            ),
            SizedBox(height: 15,),
            Text('메모', style: TextStyle(
                fontSize: 24
            ),),
            SizedBox(height: 5,),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.14,
              padding: EdgeInsets.only(top:10, left: 15),
              decoration: BoxDecoration(
                  color: Color(0xffFFF5DB),
                  borderRadius: BorderRadius.circular(15)
              ),
              alignment: Alignment.topLeft,
              child: Text(memo ?? '-'
                , style: TextStyle(
                fontSize: 24,
              ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

            if (authController.isPatient)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextButton(
                  onPressed: () async {
                    await ScheduleService().completeSchedule(docRef);
                    await addNotification(
                        '일정 알림',
                        '${authController.userName}님이 \'${name}\' 일정을 완료하셨어요!',
                        DateTime.now(),
                        false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScheduleFinish1(name: name)),
                    );
                  },
                  child: Text('일정 완료하기', style: TextStyle(color: Colors.white, fontSize: 20),),
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
