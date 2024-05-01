// 피그마 '일정 완료하기 1' 화면
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/screen/schedule/finish/ScheduleFinish2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../RoutineScheduleMain.dart';

class ScheduleFinish1 extends StatelessWidget {
  const ScheduleFinish1({super.key, required this.name});
  final name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFC215),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('lib/assets/images/new_finish_atti.png'),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(left: 15),
                child: Text('\'${name}\'\n일정을 완료했어요!', style: TextStyle(
                      fontSize: 36, fontWeight: FontWeight.w600, color: Colors.white
                  ),),
              ),
              SizedBox(height: 20,),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Get.to(RoutineScheduleMain());
              },
              child: Text('일과/일정으로 돌아가기', style: TextStyle(color: Colors.black, fontSize: 20),),
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
