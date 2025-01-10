import 'package:atti/commons/YesNoActionButtons.dart';
import 'package:atti/data/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/routine/routine_controller.dart';
import '../../../../commons/RoutineBox.dart';
import '../../../../commons/colorPallet.dart';
import '../../../../data/notification/notification_controller.dart';
import 'RoutineRegister1.dart';
import 'RoutineRegisterFinish.dart';
import '../../../../data/notification/notification.dart';

class RoutineRegisterCheck extends StatefulWidget {
  const RoutineRegisterCheck({super.key});

  @override
  State<RoutineRegisterCheck> createState() => _RoutineRegisterCheckState();
}

class _RoutineRegisterCheckState extends State<RoutineRegisterCheck> {
  final RoutineController routineController = Get.put(RoutineController());
  NotificationService notificationService = NotificationService();
  bool isButtonEnabled = true; // 버튼 활성화 여부를 나타내는 변수
  final ColorPallet colorPallet = Get.put(ColorPallet());

  // ['월', '수', '금'] -> [1, 3, 5]
  List<int> mapDaysToNumbers(List<String> repeatDays) {
    // 요일 문자열을 숫자로 매핑하기 위한 Map
    final dayMapping = {
      '월': 1,
      '화': 2,
      '수': 3,
      '목': 4,
      '금': 5,
      '토': 6,
      '일': 7,
    };

    // 문자열 리스트를 숫자 리스트로 변환
    return repeatDays.map((day) => dayMapping[day]!).toList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '일과 등록하기',
                  description: '다음과 같이 등록할까요?',
                  totalStep: 0, currentStep: 0,
                ),
                SizedBox(height: 30,),
                RoutineBox(
                  time: routineController.routine.value?.time ?? '',
                  name: routineController.routine.value?.name ?? '',
                  img: routineController.routine.value?.img ?? '',
                  days: (routineController.routine.value?.repeatDays ?? []).map<String>((day) => day.toString()).toList(), // 형 변환 및 기본값 할당
                ),

              ],
            ),
          )
          ),

          YesNoActionButtons(
              primaryText: '등록',
              secondaryText: '수정',

              onPrimaryPressed: () async {
                // setState(() {
                //   isButtonEnabled = false; // 버튼 비활성화
                // });

                routineController.routine.value.isMedicine = false;
                String tmpName = routineController.routine.value.name!;
                String tmpImg = routineController.routine.value.img!;
                List<int> tmpTime = routineController.routine.value.time!;

                //print(routineController.routine.value.repeatDays);
                final updatedRoutine = await routineController.addRoutine();

                // 루틴 알림 예약 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
                if (authController.isPatient) {
                  //notificationService.routineNotifications();
                  notificationService.showWeeklyNotification(
                      routineController.routine.value.name!,
                      mapDaysToNumbers(routineController.routine.value.repeatDays!),
                      routineController.routine.value.time![0],
                      routineController.routine.value.time![1],
                      updatedRoutine.reference!
                  );
                }
                // setState(() {
                //   isButtonEnabled = true; // 버튼 다시 활성화
                // });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoutineRegisterFinish(
                    name: tmpName, time: tmpTime, img: tmpImg,
                  )),
                );
              },

              onSecondaryPressed: () {
                Get.to(RoutineRegister1);
              }),

          // Container(
          //   margin: EdgeInsets.only(bottom: 20),
          //   child: TextButton(
          //     onPressed: isButtonEnabled ? () async {
          //       setState(() {
          //         isButtonEnabled = false; // 버튼 비활성화
          //       });
          //
          //       String tmpName = routineController.routine.value.name!;
          //       String tmpImg = routineController.routine.value.img!;
          //       List<int> tmpTime = routineController.routine.value.time!;
          //
          //       //print(routineController.routine.value.repeatDays);
          //       await routineController.addRoutine();
          //       if (authController.isPatient) {
          //         notificationService.routineNotifications();
          //       }
          //
          //       setState(() {
          //         isButtonEnabled = true; // 버튼 다시 활성화
          //       });
          //
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => RoutineRegisterFinish(
          //           name: tmpName, time: tmpTime, img: tmpImg,
          //         )),
          //       );
          //     } : null, // 버튼이 비활성화되면 onPressed를 null로 설정하여 클릭이 불가능하도록 함
          //     child: Text('등록', style: TextStyle(color: Colors.white, fontSize: 20),),
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
          //       minimumSize: MaterialStateProperty.all(
          //           Size(MediaQuery.of(context).size.width * 0.9, 50)),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
