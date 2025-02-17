// 루틴 등록하기1 화면
import 'package:atti/commons/RegisterTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import '../../../../../commons/colorPallet.dart';
import 'MedicineRoutineRegister2.dart';

class MedicineRoutineRegister1 extends StatefulWidget {
  const MedicineRoutineRegister1({super.key});

  @override
  State<MedicineRoutineRegister1> createState() => _MedicineRoutineRegister1State();
}

class _MedicineRoutineRegister1State extends State<MedicineRoutineRegister1> {
  final RoutineController routineController = Get.put(RoutineController());
  final ColorPallet colorPallet = Get.put(ColorPallet());

  @override
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
                  const DetailPageTitle(
                    title: '복약 일과 등록하기',
                    description: '복약 일과를 입력해주세요',
                    totalStep: 3,
                    currentStep: 1,
                  ),
                  SizedBox(height: width * 0.04,),
                  RegisterTextField(
                      hintText: '약 종류를 포함해 입력해주세요',
                      onChanged: (value) {
                        routineController.routine.value.name = value;
                        //print(scheduleController.name.value);
                      }),
                  SizedBox(height: width * 0.015,),

                  SizedBox(
                    width: width * 0.9,
                    child: Text(
                      '예시. \'혈압약 복용\'',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        color: colorPallet.grey
                      ),
                    ),
                  ),

                ],
              ),
            )),

            BottomNextButton(next: const MedicineRoutineRegister2(), content: '다음', isEnabled: routineController.routine.value.name != null,)
          ],
        ),
      ),
    );
  }
}
