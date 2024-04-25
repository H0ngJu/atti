// 피그마 '일정 등록 완료' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/schedule/schedule_controller.dart';

import '../ScheduleMain.dart';

class ScheduleRegisterFinish extends StatelessWidget {
  const ScheduleRegisterFinish({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleController scheduleController = Get.put(ScheduleController());
    return Scaffold(
      backgroundColor: Color(0xffFFEEBC),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(left: 15),
                  child: Text('\'${scheduleController.tmpScheduleName.value}\'\n일정을 등록했어요!',
                    style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w600, color: Color(0xffA38130)
                  ),),
                ),
                SizedBox(height: 30,),
                Container(
                  //margin: EdgeInsets.only(left: 50),
                  child: Image.asset('lib/assets/images/schedule_atti.png',
                    width: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleMain()),
                );
              },
              child: Text('일정으로 돌아가기', style: TextStyle(color: Colors.black, fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
