import 'package:atti/commons/AttiAppBar.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/screen/report/ReportDetail.dart';
import 'package:atti/screen/report/ReportHistory.dart';
// import 'package:atti/screen/report/WeeklyData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/auth_controller.dart';
import '../data/notification/notification.dart';
import '../data/notification/notification_controller.dart';
import '../data/routine/routine_model.dart';
import '../data/routine/routine_service.dart';
import '../data/schedule/schedule_model.dart';
import '../data/schedule/schedule_service.dart';

class HomeCarer extends StatefulWidget {
  const HomeCarer({Key? key}) : super(key: key);

  @override
  _HomeCarerState createState() => _HomeCarerState();
}

class _HomeCarerState extends State<HomeCarer> {
  // bottom Navi logic
  int _selectedIndex = 2;
  final _authentication = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  User? loggedUser;
  final AuthController authController = Get.find<AuthController>();

  DateTime _selectedDay = DateTime.now();
  List<ScheduleModel> schedulesBySelectedDay = []; // 선택된 날짜의 일정들이 반환되는 리스트
  int? numberOfSchedules; // 선택된 날짜의 일정 개수
  int? numberOfDoneSchedules; // 선택된 날짜의 완료된 일정 개수

  List<RoutineModel> routinesBySelectedDay = []; // 선택된 요일의 루틴 반환
  int? numberOfRoutines; // 선택된 요일의 루틴 개수
  int? numberOfDoneRoutines; // 선택된 날짜의 완료된 일과 개수
  String selectedDayInWeek = DateFormat('E', 'ko-KR').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   await _fetchData();
    _fetchData();
    // });
    getCurrentUser();
    _requestNotificationPermissions();
  }

  Future<void> _fetchData() async {
    List<ScheduleModel>? fetchedSchedules =
        await ScheduleService().getSchedulesByDate(_selectedDay);
    List<RoutineModel> fetchedRoutines =
        await RoutineService().getRoutinesByDay(selectedDayInWeek);
    if (fetchedSchedules != null) {
      int doneSchedulesCount = fetchedSchedules
          .where((schedule) => schedule.isFinished ?? false)
          .length;
      int doneRoutinesCount = fetchedSchedules
          .where((routines) => routines.isFinished ?? false)
          .length;
      setState(() {
        schedulesBySelectedDay = fetchedSchedules;
        routinesBySelectedDay = fetchedRoutines;
        numberOfSchedules = schedulesBySelectedDay.length;
        numberOfRoutines = routinesBySelectedDay.length;
        numberOfDoneSchedules = doneSchedulesCount;
        numberOfDoneRoutines = doneRoutinesCount;
      });
    } else {
      setState(() {
        schedulesBySelectedDay = [];
        numberOfSchedules = 0;
        numberOfRoutines = 0;
        numberOfDoneSchedules = 0;
        numberOfDoneRoutines = 0;
      });
    }
  }

  void _requestNotificationPermissions() async {
    NotificationService notificationService = NotificationService();
    final status = await NotificationService().requestNotificationPermissions();
    bool isGranted = await NotificationService().requestBatteryPermissions();
    notificationService.showDailyNotification();
    notificationService.showWeeklyCarerNotification();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      print("loggedUser: ${user!.uid}");
      print("check: ${authController.userName.value}");
      if (user != null) {
        loggedUser = user as User?;
      }
      ;
    } catch (e) {
      print(e);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AttiAppBar(
        title: Image.asset(
          'lib/assets/logo2.png',
          width: 150,
        ),
        showNotificationsIcon: true,
        showPersonIcon: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: HomePatientTop(userName: authController.userName.value)),
            Container(
                margin: EdgeInsets.all(16),
                child: HomeTodaySummary(
                  scheduleCnt: numberOfSchedules,
                  routineCnt: numberOfRoutines,
                  userName: authController.userName.value,
                  doneScheduleCnt: numberOfDoneSchedules,
                  doneRoutineCnt: numberOfDoneRoutines,
                )),
            Container(
              margin: EdgeInsets.all(16),
              child: HomeReport(),
            )
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

// 메인 첫 화면
class HomePatientTop extends StatefulWidget {
  final String userName;

  const HomePatientTop({Key? key, required this.userName}) : super(key: key);

  @override
  State<HomePatientTop> createState() => _HomePatientTopState();
}

class _HomePatientTopState extends State<HomePatientTop> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName; // userName 받음
    // 시간 가져오기
    DateTime now = DateTime.now();
    String weekday = _getWeekday(now.weekday);

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 열을 위에서부터 시작하도록 정렬
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
        children: [
          SizedBox(height: 25),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, height: 1.2),
              children: [
                TextSpan(
                  text: '${widget.userName} 보호자님\n',
                  style: TextStyle(fontSize: 24),
                ),
                TextSpan(
                  text: '안녕하세요?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
          ),
          SizedBox(height: 14), // 간격을 추가하여 텍스트와 이미지를 구분
          Row(
            // 이미지를 중앙 정렬하기 위한 Row 위젯
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              Image(
                  image: AssetImage('lib/assets/Atti/standingAtti.png'),
                  width: MediaQuery.of(context).size.width * 0.8),
            ],
          ),
          SizedBox(height: 10), // 간격을 추가하여 이미지와 텍스트를 구분
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xffFFC215),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Text(
                '오늘은\n${now.year}년 ${now.month}월 ${now.day}일 ${weekday}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontFamily: 'UhBee', fontSize: 25)),
          ),
        ],
      ),
    );
  }

  // 요일을 반환하는 함수
  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }
}

// 오늘의 일정, 일과
class HomeTodaySummary extends StatefulWidget {
  final int? scheduleCnt;
  final int? doneScheduleCnt;
  final int? routineCnt;
  final int? doneRoutineCnt;
  final String userName;

  const HomeTodaySummary(
      {Key? key,
      required this.scheduleCnt,
      required this.routineCnt,
      required this.userName,
      required this.doneScheduleCnt,
      required this.doneRoutineCnt})
      : super(key: key);

  @override
  State<HomeTodaySummary> createState() => _HomeTodaySummaryState();
}

class _HomeTodaySummaryState extends State<HomeTodaySummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(
              '${widget.userName}님이 진행하고 있어요!',
              style: TextStyle(fontSize: 28, fontFamily: 'PretendardMedium'),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 132,
                  // 정적으로 고정할 것인가?
                  margin: EdgeInsets.only(right: 8),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: Color(0xffDDDDDD),
                      width: 1,
                    ),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontSize: 24, height: 1.5),
                      children: [
                        TextSpan(text: '일과 완료\n'),
                        TextSpan(
                            text:
                                '${widget.doneRoutineCnt}/${widget.routineCnt}',
                            style: TextStyle(
                              fontSize: 30,
                              //fontWeight: FontWeight.bold,
                              //color: Color(0xffFFC215)
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 132,
                  // 정적으로 고정할 것인가?
                  margin: EdgeInsets.only(left: 8),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: Color(0xffDDDDDD),
                      width: 1,
                    ), // 테두리 추가
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontSize: 24, height: 1.5),
                      children: [
                        TextSpan(text: '일정 완료\n'),
                        TextSpan(
                            text:
                                '${widget.doneScheduleCnt}/${widget.scheduleCnt}',
                            style: TextStyle(
                              fontSize: 30,
                              //fontWeight: FontWeight.bold,
                              //color: Color(0xffFFC215)
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ]);
  }
}

class HomeReport extends StatefulWidget {
  const HomeReport({Key? key}) : super(key: key);

  @override
  _HomeReportState createState() => _HomeReportState();
}

class _HomeReportState extends State<HomeReport> {
  List<ScheduleModel> weeklySchedules = [];
  List<RoutineModel> weeklyRoutines = [];
  int totalSchedules = 0;
  int totalRoutines = 0;
  int doneSchedules = 0;
  int doneRoutines = 0;

  @override
  void initState() {
    super.initState();
    _fetchWeeklyData();
  }

  Future<void> _fetchWeeklyData() async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    List<ScheduleModel> fetchedSchedules =
        await ScheduleService().getSchedulesInRange(startOfWeek, endOfWeek);
    List<RoutineModel> fetchedRoutines =
        await RoutineService().getRoutinesInRange(startOfWeek, endOfWeek);

    setState(() {
      weeklySchedules = fetchedSchedules;
      weeklyRoutines = fetchedRoutines;
      totalSchedules = weeklySchedules.length;
      totalRoutines = weeklyRoutines.length;
      doneSchedules = weeklySchedules
          .where((schedule) => schedule.isFinished ?? false)
          .length;
      doneRoutines = weeklyRoutines
          .where((routine) =>
              routine.isFinished != null &&
              routine.isFinished!.values.any((v) => v))
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekOfMonth = getWeekOfMonth(now);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${now.month}월 ${weekOfMonth}주차 기록 보고',
            style: TextStyle(fontSize: 30, fontFamily: 'PretendardMedium'),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffDDDDDD)),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        // 왼쪽 정렬을 위해 Expanded로 감싸줍니다.
                        child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        '일과 완료율',
                        style: TextStyle(
                            fontFamily: 'PretendardRegular', fontSize: 24),
                      ),
                    )),
                    Expanded(
                        // 오른쪽 정렬을 위해 Expanded로 감싸줍니다.
                        child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        '${(doneRoutines / totalRoutines * 100).toStringAsFixed(1)} %',
                        textAlign: TextAlign.right, // 텍스트를 오른쪽으로 정렬합니다.
                        style: TextStyle(
                            color: Color(0xffA38130),
                            fontFamily: 'PretendardRegular',
                            fontSize: 24),
                      ),
                    ))
                  ],
                ),
                Divider(color: Color(0xffDDDDDD)),
                Row(
                  children: [
                    Expanded(
                        // 왼쪽 정렬
                        child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text('일정 완료율',
                          style: TextStyle(
                              fontFamily: 'PretendardRegular', fontSize: 24)),
                    )),
                    Expanded(
                        // 오른쪽 정렬
                        child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        '${(doneSchedules / totalSchedules * 100).toStringAsFixed(1)} %',
                        textAlign: TextAlign.right, // 텍스트를 오른쪽으로 정렬합니다.
                        style: TextStyle(
                            color: Color(0xffA38130),
                            fontFamily: 'PretendardRegular',
                            fontSize: 24),
                      ),
                    ))
                  ],
                ),
                Divider(color: Color(0xffDDDDDD)),
                Row(
                  children: [
                    Expanded(
                        // 왼쪽 정렬
                        child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text('최다 열람 기억',
                          style: TextStyle(
                              fontFamily: 'PretendardRegular', fontSize: 24)),
                    )),
                    Expanded(
                        // 오른쪽 정렬
                        child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        '뭘까용',
                        textAlign: TextAlign.right, // 텍스트를 오른쪽으로 정렬합니다.
                        style: TextStyle(
                            color: Color(0xffA38130),
                            fontFamily: 'PretendardRegular',
                            fontSize: 24),
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return WeeklySummaryWidget();
              // }));
            },
            child: Text(
              '${now.month}월 ${weekOfMonth}주차 기록 보고 보기',
              style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width, 60)), // 가로 150, 세로 50
              backgroundColor: MaterialStateProperty.all(Color(0xffFFF5DB)),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 10)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              )),
            ),
          ),
        ],
      ),
    );
  }

  int getWeekOfMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final weekdayOfFirstDay = firstDayOfMonth.weekday;
    final firstSunday =
        firstDayOfMonth.subtract(Duration(days: weekdayOfFirstDay - 1));
    final difference = date.difference(firstSunday).inDays;
    final weekNumber = (difference / 7).ceil();
    return weekNumber;
  }
}
