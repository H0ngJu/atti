// 피그마 '일정 등록하기' 화면
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  var name = ''.obs;
  var time = ''.obs;
  var location = ''.obs;
  var memo = ''.obs;
}

class ScheduleRegister1 extends StatefulWidget {
  const ScheduleRegister1({super.key});

  @override
  State<ScheduleRegister1> createState() => _ScheduleRegister1State();
}

class _ScheduleRegister1State extends State<ScheduleRegister1> {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '일정 등록하기',
                  description: '일정 이름을 입력해주세요',
                  totalStep: 6,
                  currentStep: 1,
                ),
                SizedBox(height: 40),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    onChanged: (value) {
                      scheduleController.name.value = value;
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: '예정된 일정이 무엇인가요?',
                      hintStyle: TextStyle(fontSize: 20),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleRegister2()));
          },
          child: Text(
            '다음',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey),
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ))),
        )
      ]),
    );
  }
}

class ScheduleRegister2 extends StatefulWidget {
  const ScheduleRegister2({super.key});

  @override
  State<ScheduleRegister2> createState() => _ScheduleRegister2State();
}

class _ScheduleRegister2State extends State<ScheduleRegister2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DetailPageTitle(
              title: '일정 등록하기',
              description: '일정 시간을 선택해주세요',
              totalStep: 6,
              currentStep: 2,
            ),
          ],
        ),
      ),
    );
  }
}
