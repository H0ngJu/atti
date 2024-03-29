import 'package:atti/data/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/routine/routine_controller.dart';
import '../../../commons/RoutineBox.dart';
import '../../../data/notification/notification_controller.dart';
import 'RoutineRegisterFinish.dart';

class RoutineRegisterCheck extends StatefulWidget {
  const RoutineRegisterCheck({super.key});

  @override
  State<RoutineRegisterCheck> createState() => _RoutineRegisterCheckState();
}

class _RoutineRegisterCheckState extends State<RoutineRegisterCheck> {
  final RoutineController routineController = Get.put(RoutineController());
  NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '하루일과 등록하기  ',
                  description: '다음과 같이 등록할까요?',
                  totalStep: 0, currentStep: 0,
                ),
                SizedBox(height: 30,),
                RoutineBox(
                  time: routineController.routine.value.time,
                  name: routineController.routine.value.name,
                  img: routineController.routine.value.img,
                  days: routineController.routine.value.repeatDays,
                ),

              ],
            ),
          )),

          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                routineController.tmpRoutineName.value = routineController.routine.value.name!;
                print(routineController.routine.value.repeatDays);
                routineController.addRoutine();

                if (authController.isPatient) {
                  notificationService.routineNotifications();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoutineRegisterFinish()),
                );
              },
              child: Text('등록', style: TextStyle(color: Colors.white, fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
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
