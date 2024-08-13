// 루틴 등록하기1 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'RoutineRegister2.dart';

class RoutineRegister1 extends StatefulWidget {
  const RoutineRegister1({super.key});

  @override
  State<RoutineRegister1> createState() => _RoutineRegister1State();
}

class _RoutineRegister1State extends State<RoutineRegister1> {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
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
                    title: '일과 등록하기  ',
                    description: '일과 이름을 입력해주세요',
                    totalStep: 3,
                    currentStep: 1,
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      onChanged: (value) {
                        routineController.routine.value.name = value;
                        //print(scheduleController.name.value);
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: '일과 이름이 무엇인가요?',
                        hintStyle: TextStyle(fontSize: 24, color: Color(0xffA38130)),
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFF5DB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(15), // 위아래 여백 조절
                      ),
                    ),
                  ),
                ],
              ),
            )),

            NextButton(next: RoutineRegister2(), content: '다음', isEnabled: routineController.routine.value.name != null,)
          ],
        ),
      ),
    );
  }
}
