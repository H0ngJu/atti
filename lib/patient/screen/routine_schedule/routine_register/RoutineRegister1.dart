// 루틴 등록하기1 화면
import 'package:atti/commons/RegisterTextField.dart';
import 'package:atti/patient/screen/routine_schedule/routine_register/medicine_routine_register/MedicineRoutineRegister1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import '../../../../commons/colorPallet.dart';
import '../../../../data/auth_controller.dart';
import 'RoutineRegister2.dart';

class RoutineRegister1 extends StatefulWidget {
  const RoutineRegister1({super.key});

  @override
  State<RoutineRegister1> createState() => _RoutineRegister1State();
}

class _RoutineRegister1State extends State<RoutineRegister1> {
  final RoutineController routineController = Get.put(RoutineController());
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    print("환자 도큐먼트 레퍼런스 여기여기!!!!!!!!!!!!");
    print(authController.patientDocRef);
  }

  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailPageTitle(
                    title: '일과 등록하기',
                    description: '일과 이름을 입력해주세요',
                    totalStep: 3,
                    currentStep: 1,
                  ),
                  SizedBox(height: width * 0.04,),
                  RegisterTextField(
                      hintText: '어떤 일과인가요?',
                      onChanged: (value) {
                        routineController.routine.value.name = value;
                        //print(scheduleController.name.value);
                      }),
                  SizedBox(height: width * 0.08,),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '복약 일과라면\n아래의 초록 버튼을 눌러주세요'
                        , style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          height: 1.2
                      ),),
                    ),
                  ),
                  SizedBox(height: width * 0.04,),
                  Row(
                    children: [
                      SizedBox(width: width * 0.05,),
                      GestureDetector(
                        onTap: () {
                          Get.to(MedicineRoutineRegister1());
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                            color: Color(0xff64A94C),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: Text(
                            '복약일과 등록하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            )),

            BottomNextButton(next: RoutineRegister2(), content: '다음', isEnabled: routineController.routine.value.name != null,)
          ],
        ),
      ),
    );
  }
}
