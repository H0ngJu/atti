// 피그마 '일정 등록하기 2' 화면
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
                    totalStep: 6,
                    currentStep: 2,
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '날짜 선택',
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: '시간 선택',
                        labelStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(Icons.access_time),
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
