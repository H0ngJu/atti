// 피그마 '일정 등록하기 2 - 일정 날짜, 시간' 화면
import 'package:atti/commons/RegisterTextField.dart';
import 'package:atti/index.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:atti/data/schedule/schedule_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

import 'package:atti/tmp/screen/schedule/register/ScheduleRegister3.dart';
import 'package:intl/intl.dart';

import '../../../../commons/colorPallet.dart';

class ScheduleRegister2 extends StatefulWidget {
  const ScheduleRegister2({super.key});

  @override
  State<ScheduleRegister2> createState() => _ScheduleRegister2State();
}

class _ScheduleRegister2State extends State<ScheduleRegister2> {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final ColorPallet colorPallet = Get.put(ColorPallet());

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // 타임스탬프 변환용
  DateTime? date;
  TimeOfDay? time;

  // 날짜 선택 달력
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
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

    if (datePicked != null) {
      setState(() {
        selectedDate = datePicked;
        _dateController.text = DateFormat('yyyy년 MM월 dd일').format(selectedDate!);

        date = DateFormat('yyyy년 MM월 dd일').parse(_dateController.text);
      });
    }
  }

  // 시간 선택 시계
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
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

    if (timePicked != null) {
      setState(() {
        selectedTime = timePicked;
        _timeController.text = timePicked.format(context);

        final parts = _timeController.text.split(' ');
        final timeParts = parts[1].split(':');
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        if (parts[0] == '오후' && hour != 12) { // '오후'인 경우에는 시간에 12를 더함
          hour += 12;
        }

        time = TimeOfDay(hour: hour, minute: minute);
        final combineDateTime = DateTime(
            date!.year, date!.month, date!.day, time!.hour, time!.minute
        );
        scheduleController.schedule.value.time = Timestamp.fromDate(combineDateTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // location 초기값 설정
    scheduleController.schedule.value.location = scheduleController.schedule.value.location ?? "";
  }

  @override
  Widget build(BuildContext context) {

    bool isButtonEnabled() {
      // print('Date: ${_dateController.text}');
      // print('Time: ${_timeController.text}');
      // print('Location: ${scheduleController.schedule.value.location}');
      return _dateController.text.isNotEmpty &&
          _timeController.text.isNotEmpty &&
          (scheduleController.schedule.value.location?.trim().isNotEmpty ?? false);
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailPageTitle(
                    title: '일정 등록하기',
                    description: '일정 시작 날짜와\n시간을 선택해주세요',
                    totalStep: 3,
                    currentStep: 2,
                  ),
                  SizedBox(height: width * 0.03,),

                  // 날짜 선택
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        print("날짜 선택 여부");
                        print(_dateController);
                        await _selectDate(context);
                        },
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFF5DB),
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
                  SizedBox(height: 15),

                  // 시간 선택
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _timeController,
                      readOnly: true,
                      onTap: () async {
                        print("시간 선택 여부");
                        print(_timeController.text);
                        await _selectTime(context);
                        },
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        filled: true, // 배경을 채움
                        fillColor: Color(0xffFFF5DB),
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
                  SizedBox(height: width * 0.08,),

                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      child: Text(
                      '일정 장소를 입력해주세요'
                      , style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          height: 1.2
                      ),),
                    ),
                  ),
                  SizedBox(height: width * 0.03,),

                  RegisterTextField(
                      hintText: '예정된 장소가 어디인가요?',
                      onChanged: (value) {
                        scheduleController.schedule.value.location = value;
                        //print(scheduleController.name.value);
                      })


                ],
              ),
            ),
          ),

          BottomNextButton(
              next: ScheduleRegister4(),
              content: '다음',
              isEnabled: isButtonEnabled()),
        ],
      ),

    );
  }
}
