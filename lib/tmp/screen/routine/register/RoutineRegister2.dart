// 루틴 등록하기1 화면
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'RoutineRegister3.dart';

class RoutineRegister2 extends StatefulWidget {
  const RoutineRegister2({super.key});

  @override
  State<RoutineRegister2> createState() => _RoutineRegister2State();
}

class _RoutineRegister2State extends State<RoutineRegister2> {
  final RoutineController routineController = Get.put(RoutineController());
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? selectedTime;

  final List<String> days = ['월', '화', '수', '목', '금', '토', '일'];
  late List<bool> selectedDays = [false, false, false, false, false, false, false];
  late List<String> selectedDaysInWeek = [];

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
              onSurface: Colors.black, // 시, 분, 오전/오후 숫자
              secondary: Color(0xffFFF5DB), // 오전/오후 선택된 영역
              onSecondary: Color(0xffA38130), // 오전/오후 선택된 영역의 글자
              outline: Color(0xffA38130),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (timePicked != null) {
      setState(() {
        final int hour = timePicked.hour;
        final int minute = timePicked.minute;
        final bool isPM = hour >= 12; // 오후 여부 확인

        // 12시간 형식으로 변환
        int hour12 = hour > 12 ? hour - 12 : hour;
        hour12 = hour12 == 0 ? 12 : hour12;

        // 선택한 시간을 텍스트필드에 표시
        _timeController.text = '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

        // RoutineModel의 time에 Timestamp로 저장
        final selectedDateTime = DateTime.now().add(Duration(hours: hour, minutes: minute));
        routineController.routine.value.time = [hour, minute];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
              SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container( // 뒤로가기 아이콘
                          //margin: EdgeInsets.only(top: 50, left: 5),
                            child: IconButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, icon: Icon(Icons.arrow_back_ios_outlined, size: 25))),
                        //SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text('일과 등록하기  ', style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500
                          ),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 12.toDouble() * 3,
                          child: StepProgressIndicator(
                              totalSteps: 3,
                              currentStep: 2,
                              size: 6,
                              padding: 3,
                              selectedColor: Color(0xffFFC215),
                              unselectedColor: Color(0xffCDCDCD)
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text('반복할 시간을 선택해주세요', textAlign: TextAlign.left, style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w500
                  ),),
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: () async {
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
                SizedBox(height: 50),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text('반복할 요일을 선택해주세요', textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w500
                  ),),
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                    child: SelectDaysButtons()),


              ],
            ),
          )),
          BottomNextButton(next: RoutineRegister3(), content: '다음', isEnabled: routineController.routine.value.repeatDays != null &&
              routineController.routine.value.time != null,)
        ],
      ),
    );
  }

  Widget SelectDaysButtons() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 10, // 가로 간격 설정
      runSpacing: 10, // 세로 간격 설정
      children: List.generate(days.length, (index) {
        return TextButton(
          onPressed: () {
            setState(() {
              selectedDays[index] = !selectedDays[index];
              if (selectedDays[index]) {
                selectedDaysInWeek.add(days[index]);
                routineController.routine.value.repeatDays = selectedDaysInWeek;
              } else {
                selectedDaysInWeek.remove(days[index]);
                routineController.routine.value.repeatDays = selectedDaysInWeek;
              }
              print(selectedDaysInWeek);
            });
          },
          child: Text(days[index]),
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontSize: 24), // 텍스트 크기
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (selectedDays[index]) {
                  return Colors.white; // 선택됐을 때 텍스트 색상
                } else {
                  return Color(0xffA38130); // 선택되지 않았을 때 텍스트 색상
                }
              },
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (selectedDays[index]) {
                  return Color(0xffFFC215); // 선택됐을 때 배경색
                } else {
                  return Color(0xffFFF5DB); // 선택되지 않았을 때 배경색
                }
              },
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.all(5), // 버튼 내부 패딩 설정
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // 버튼 모서리 둥글기 설정
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
