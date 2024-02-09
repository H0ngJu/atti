// 피그마 '일정 등록하기 2 - 일정 날짜, 시간' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/controller/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/screen/schedule/register/ScheduleRegister3.dart';
import 'package:intl/intl.dart';

class ScheduleRegister2 extends StatefulWidget {
  const ScheduleRegister2({super.key});

  @override
  State<ScheduleRegister2> createState() => _ScheduleRegister2State();
}

class _ScheduleRegister2State extends State<ScheduleRegister2> {
  final ScheduleController scheduleController = Get.put(ScheduleController());

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool isButtonEnabled() {
    return _dateController.text.isNotEmpty && _timeController.text.isNotEmpty;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              //surface: Color(0xffFFF5DB), // 배경 색
              onSurface: Colors.black, // 달력 숫자 색
              primary: Color(0xffFFE9B3), // 선택된 영역 색
              onPrimary: Color(0xffA38130), // 선택된 날짜 숫자 색
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black // button text color
              )
            )
          ),
          child: child!,
        );
      }
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        scheduleController.date.value = _dateController.text as DateTime;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xffFFE9B3), // 선택된 영역
                  onPrimary: Color(0xffA38130), // 선택된 곳 숫자
                  //surface: Color(0xffFFF5DB), // 전체 배경
                  onSurface: Colors.black, // 시, 분, 오전/오후 숫자
                  secondary: Color(0xffFFF5DB), // 오전/오후 선택된 영역
                  onSecondary: Color(0xffA38130), // 오전/오후 선택된 영역의 글자
                  outline: Color(0xffA38130),

                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black // button text color
                    )
                )
            ),
            child: child!,
          );
        }
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
        scheduleController.time.value = _timeController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailPageTitle(
                    title: '일정 등록하기',
                    description: '일정 시간을 선택해주세요',
                    totalStep: 5,
                    currentStep: 2,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFE9B3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: '날짜 선택',
                        hintStyle: TextStyle(color: Color(0xffA38130)),
                        suffixIcon: Icon(Icons.calendar_today, color: Color(0xffA38130)),
                        contentPadding: EdgeInsets.all(15),

                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFE9B3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: '시간 선택',
                        hintStyle: TextStyle(color: Color(0xffA38130)),
                        suffixIcon: Icon(Icons.access_time, color: Color(0xffA38130),),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          NextButton(next: ScheduleRegister3(), content: '다음', isEnabled: isButtonEnabled()),
        ],
      ),

    );
  }
}
