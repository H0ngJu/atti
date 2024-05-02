import 'package:atti/screen/routine/register/RoutineRegister1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import '../../commons/BottomNextButton.dart';
import '../../commons/RoutineBox.dart';
import '../../commons/RoutineModal.dart';
import '../../data/auth_controller.dart';
import '../../data/routine/routine_controller.dart';
import '../../data/routine/routine_model.dart';
import '../../data/routine/routine_service.dart';
import 'package:atti/screen/schedule/register/ScheduleRegister1.dart';
import '../../commons/ScheduleBox.dart';
import '../../commons/ScheduleModal.dart';
import '../../data/schedule/schedule_model.dart';
import 'package:atti/screen/schedule/register/ScheduleRegister1.dart';
import 'dart:math';
import '../commons/RoutineBox2.dart';
import '../data/schedule/schedule_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

// 이미지 파일 이름 목록
List<String> imageNames = [
  'EatingStar.png',
  'Napping.png',
  'ReadingBook.png',
  'Coffee.png',
  'Soccer.png',
  'Walking.png',
];

class RoutineScheduleMain extends StatefulWidget {
  const RoutineScheduleMain({super.key});

  @override
  State<RoutineScheduleMain> createState() => _RoutineScheduleMainState();
}

class _RoutineScheduleMainState extends State<RoutineScheduleMain> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  // 일정일과 요약 설명 & TTS
  FlutterTts flutterTts = FlutterTts();
  List<RoutineModel> todayRoutines = [];
  List<ScheduleModel> todaySchedules = [];
  DateTime today = DateTime.now();
  String todayInWeek = DateFormat('E', 'ko-KR').format(DateTime.now());
  String ttsMsg = '';
  String selectedMessage = '';

  final AuthController authController = Get.put(AuthController());
  final RoutineController routineController = Get.put(RoutineController());
  Random random = Random();
  DateTime _selectedDay = DateTime.now(); // 선택한 날짜 !!

  List<ScheduleModel> schedulesBySelectedDay = []; // 선택된 날짜의 일정들이 반환되는 리스트
  int? numberOfSchedules; // 선택된 날짜의 일정 개수

  List<RoutineModel> routinesBySelectedDay = []; // 선택한 요일의 루틴들
  int? numberOfRoutines;
  String selectedDayInWeek = DateFormat('E', 'ko-KR').format(DateTime.now()); // 선택한 날짜의 요일


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchData();
      _makeTTsMessage();
    });
  }

  Future<void> _fetchData() async {
    List<ScheduleModel>? fetchedSchedules = await ScheduleService().getSchedulesByDate(_selectedDay);
    List<RoutineModel> fetchedRoutines =
    await RoutineService().getRoutinesByDay(selectedDayInWeek);

    // tts를 위한 오늘의 일정, 일과
    todayRoutines = await RoutineService().getRoutinesByDay(todayInWeek);
    todaySchedules = await ScheduleService().getSchedulesByDate(today);

    if (fetchedSchedules != null) {
      setState(() {
        schedulesBySelectedDay = fetchedSchedules;
        numberOfSchedules = schedulesBySelectedDay.length;
      });
    } else {
      setState(() {
        schedulesBySelectedDay = [];
        numberOfSchedules = 0;
      });
    }

    if (fetchedRoutines != null) {
      setState(() {
        routinesBySelectedDay = fetchedRoutines;
        numberOfRoutines = routinesBySelectedDay.length;
      });
    } else {
      setState(() {
        routinesBySelectedDay = [];
        numberOfRoutines = 0;
      });
    }
  }

  Future<void> _makeTTsMessage() async {
    List<String> ttsMessages = ['오늘은 어떤 일정이 있으신가요?', '일정과 일과를 할 시간이 되면 아띠가 알려드릴게요!'];

    // 오늘 날짜
    DateTime today = DateTime.now();

    // 오늘의 일정 메시지 생성
    if (_selectedDay.year == today.year && _selectedDay.month == today.month && _selectedDay.day == today.day) {
      if (todaySchedules.isNotEmpty) {
        String ttsScheduleMessage = '오늘은 ';
        for (int i = 0; i < todaySchedules.length; i++) {
          ttsScheduleMessage += DateFormat('a h시 m분', 'ko_KR').format(todaySchedules[i].time!.toDate()) +
              '에 ' +
              todaySchedules[i].name! +
              (i == todaySchedules.length - 1 ? ' 일정이 있어요!' : ', ');
        }
        ttsMessages.add(ttsScheduleMessage);
      }

      // 오늘의 루틴 메시지 생성
      if (todayRoutines.isNotEmpty) {
        DateTime currentTime = DateTime.now();
        todayRoutines.sort((a, b) {
          int aHour = a.time![0];
          int aMinute = a.time![1];
          int bHour = b.time![0];
          int bMinute = b.time![1];
          Duration aDuration = Duration(hours: aHour, minutes: aMinute);
          Duration bDuration = Duration(hours: bHour, minutes: bMinute);
          return aDuration.compareTo(bDuration);
        });

        String? closestRoutine;
        for (int i = 0; i < todayRoutines.length; i++) {
          int routineHour = todayRoutines[i].time![0];
          int routineMinute = todayRoutines[i].time![1];
          DateTime routineTime = DateTime(today.year, today.month, today.day, routineHour, routineMinute);
          if (routineTime.isAfter(currentTime)) {
            closestRoutine = todayRoutines[i].name;
            break;
          }
        }

        if (closestRoutine != null) {
          String ttsRoutineMessage = '$closestRoutine(이)가 아직 완료되지 않았어요.';
          ttsMessages.add(ttsRoutineMessage);
        }
      }
    } else {
      // 오늘이 아닌 경우 메시지 출력
      ttsMessages.add('일과와 일정을 확인해보세요!');
      ttsMessages.add('함께 일과와 일정을 계획해볼까요?');
    }

    // 랜덤하게 메시지 선택 및 TTS 실행
    if (ttsMessages.isNotEmpty) {
      Random random = Random();
      int index = random.nextInt(ttsMessages.length);
      selectedMessage = ttsMessages[index];

      await flutterTts.setLanguage('ko-KR');
      await flutterTts.setPitch(1);
      await flutterTts.speak(selectedMessage);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: _selectedDay,
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
        _selectedDay = datePicked;
        selectedDayInWeek = DateFormat('E', 'ko-KR').format(_selectedDay);
      });
    }
  }

  String removeZ(String dateTimeString) {
    return dateTimeString.replaceAll('Z', '');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String randomImageName = imageNames[random.nextInt(imageNames.length)];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.06,),
            Container(
              width: width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                '${authController.userName.value}님의',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '일과 및 일정',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(onPressed: () async {
                    await _selectDate(context);
                    await _fetchData();
                  },
                      child: Text('날짜변경', style: TextStyle(fontSize: 18, color: Colors.black),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xffECECEC)),
                      ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('lib/assets/Atti/$randomImageName'),
                  width: width * 0.6)
              ],
            ),
            SizedBox(height: height * 0.03),
            Container(
              width: width * 0.9,
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xffFFC215),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text(
                  selectedMessage ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'UhBee', fontSize: 25)),
            ),
            SizedBox(height: height * 0.03,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${DateFormat('M월 d일 EEEE', 'ko_KR').format(_selectedDay)} 일과',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(onPressed: () {
                    Get.to(RoutineRegister1());
                  },
                    child: Text('일과등록', style: TextStyle(fontSize: 18, color: Color(0xffA38130)),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xffFFE9B3)),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: height * 0.05,),

            // 여기에 seletexDay에 해당하는 루틴들을 추가
            routinesBySelectedDay.length > 0
            ? ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: routinesBySelectedDay.length,
              itemBuilder: (context, index) {
                bool isFinished =
                    routinesBySelectedDay[index].isFinished != null &&
                        routinesBySelectedDay[index]
                            .isFinished!
                            .containsKey(removeZ(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000')) &&
                        routinesBySelectedDay[index]
                            .isFinished![removeZ(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000')]!;

                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return RoutineModal(
                            img: routinesBySelectedDay[index].img!,
                            name: routinesBySelectedDay[index].name!,
                            days: routinesBySelectedDay[index].repeatDays!,
                            docRef: routinesBySelectedDay[index].reference!,
                            time: routinesBySelectedDay[index].time!,
                            date: _selectedDay,
                            onCompleted: _fetchData,
                          );
                        });
                  },
                  child: RoutineBox2(
                    time: routinesBySelectedDay[index].time!,
                    img: routinesBySelectedDay[index].img!,
                    name: routinesBySelectedDay[index].name!,
                    isFinished: isFinished
                  ),
                );
              },
            )
            : Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      style: BorderStyle.solid, color: Color(0xffDDDDDD))),
              child: Text(
                '예정된 일과가 없어요',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: height * 0.01,),
            SizedBox(
              width: width * 0.9,
              child: Divider(
                color: Color(0xffE1E1E1),
                thickness: 1,
              ),
            ),
            SizedBox(height: height * 0.02,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${DateFormat('M월 d일 EEEE', 'ko_KR').format(_selectedDay)} 일정',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(onPressed: () {
                    Get.to(ScheduleRegister1());
                  },
                    child: Text('일정등록', style: TextStyle(fontSize: 18, color: Color(0xffA38130)),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xffFFE9B3)),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: height * 0.03,),
            schedulesBySelectedDay.length > 0
                ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: schedulesBySelectedDay.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ScheduleModal(
                                  time: DateFormat('a h시 mm분', 'ko_KR')
                                      .format(schedulesBySelectedDay[index].time!.toDate()),
                                  location: schedulesBySelectedDay[index].location!,
                                  name: schedulesBySelectedDay[index].name!,
                                  memo: schedulesBySelectedDay[index].memo,
                                  docRef: schedulesBySelectedDay[index].reference!,
                                );
                              });
                        },
                        child: ScheduleBox(
                          time: DateFormat('a hh:mm', 'ko_KR')
                              .format(schedulesBySelectedDay[index].time!.toDate()),
                          location: schedulesBySelectedDay[index].location,
                          name: schedulesBySelectedDay[index].name,
                          isFinished: schedulesBySelectedDay[index].isFinished,
                        ),
                      );
                  },
            )
                : Container(
              margin: EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                          style: BorderStyle.solid, color: Color(0xffDDDDDD))),
                  child: Text(
                    '등록된 일정이 없어요',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: height * 0.03,),

          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
