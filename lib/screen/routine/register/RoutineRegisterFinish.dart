import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';

import '../RoutineMain.dart';

class RoutineRegisterFinish extends StatefulWidget {
  const RoutineRegisterFinish({super.key});

  @override
  State<RoutineRegisterFinish> createState() => _RoutineRegisterFinishState();
}

class _RoutineRegisterFinishState extends State<RoutineRegisterFinish> {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {

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
                  child: Text('\'${routineController.tmpRoutineName.value}\'\n하루 일과를 등록했어요!',
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
                  MaterialPageRoute(builder: (context) => RoutineMain()),
                );
              },
              child: Text('하루 일과로 돌아가기', style: TextStyle(color: Colors.black, fontSize: 20),),
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
