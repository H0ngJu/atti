// 루틴 등록하기1 화면
import 'package:atti/commons/RegisterTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../../commons/colorPallet.dart';
import 'MedicineRoutineRegister3.dart';

class MedicineRoutineRegister2 extends StatefulWidget {
  const MedicineRoutineRegister2({super.key});

  @override
  State<MedicineRoutineRegister2> createState() => _MedicineRoutineRegister2State();
}

class _MedicineRoutineRegister2State extends State<MedicineRoutineRegister2> {
  final RoutineController routineController = Get.put(RoutineController());
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? selectedTime;
  final ColorPallet colorPallet = Get.put(ColorPallet());

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
                  title: '복약일과 등록하기',
                  description: '복약 시간을 선택해주세요',
                  totalStep: 3,
                  currentStep: 2,
                ),
                SizedBox(height: width * 0.04,),
                
                // 시간 선택
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    onTap: () async {
                      await _selectTime(context);
                    },
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
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
                SizedBox(height: width * 0.09,),
                Center(
                  child: Container(
                    //margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text('복약 요일을 선택해주세요', textAlign: TextAlign.left, style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w500
                    ),),
                  ),
                ),
                SizedBox(height: width * 0.04,),
                SizedBox(
                  width: width * 0.9,
                    child: SelectDaysButtons()
                ),


              ],
            ),
          )),
          BottomNextButton(next: MidicineRoutineRegister3(), content: '다음', isEnabled: routineController.routine.value.repeatDays != null &&
              routineController.routine.value.time != null,)
        ],
      ),
    );
  }

  Widget SelectDaysButtons() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 5, // 가로 간격 설정
      runSpacing: 5, // 세로 간격 설정
      children: List.generate(days.length, (index) {
        return Container(
          width: width * 0.115,
          height: width * 0.115,
          child: TextButton(
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
              textStyle: WidgetStateProperty.all<TextStyle>(
                TextStyle(fontSize: 23), // 텍스트 크기
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                  if (selectedDays[index]) {
                    return Colors.black; // 선택됐을 때 텍스트 색상
                  } else {
                    return Colors.black; // 선택되지 않았을 때 텍스트 색상
                  }
                },
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                  if (selectedDays[index]) {
                    return colorPallet.goldYellow; // 선택됐을 때 배경색
                  } else {
                    return Colors.white; // 선택되지 않았을 때 배경색
                  }
                },
              ),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.fromLTRB(0, 2, 0, 5), // 버튼 내부 패딩 설정
              ),
              shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: Colors.black,
                    width: 1
                  )// 버튼 모서리 둥글기 설정
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
