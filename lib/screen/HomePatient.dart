import 'dart:ffi';
import 'package:atti/commons/AttiAppBar.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:atti/screen/schedule/ScheduleMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/auth_controller.dart';
import '../data/notification/notification.dart';
import '../data/routine/routine_model.dart';
import '../data/routine/routine_service.dart';
import '../data/schedule/schedule_model.dart';
import '../data/schedule/schedule_service.dart';

class HomePatient extends StatefulWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  _HomePatientState createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {
  final _authentication = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  User? loggedUser;
  final AuthController authController = Get.put(AuthController());

  DateTime _selectedDay = DateTime.now();
  List<ScheduleModel> schedulesBySelectedDay = []; // 선택된 날짜의 일정들이 반환되는 리스트
  int? numberOfSchedules; // 선택된 날짜의 일정 개수

  List<RoutineModel> routinesBySelectedDay = []; // 선택된 요일의 루틴 반환
  int? numberOfRoutines; // 선택된 요일의 루틴 개수
  String selectedDayInWeek = DateFormat('E', 'ko-KR').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchData();
    });
    getCurrentUser();
    _requestNotificationPermissions();
  }

  Future<void> _fetchData() async {
    List<ScheduleModel>? fetchedSchedules =
        await ScheduleService().getSchedulesByDate(_selectedDay);
    List<RoutineModel> fetchedRoutines =
        await RoutineService().getRoutinesByDay(selectedDayInWeek);
    if (fetchedSchedules != null) {
      setState(() {
        schedulesBySelectedDay = fetchedSchedules;
        routinesBySelectedDay = fetchedRoutines;
        numberOfSchedules = schedulesBySelectedDay.length;
        numberOfRoutines = routinesBySelectedDay.length;
      });
    } else {
      setState(() {
        schedulesBySelectedDay = [];
        numberOfSchedules = 0;
        numberOfRoutines = 0;
      });
    }
  }

  void _requestNotificationPermissions() async {
    NotificationService notificationService = NotificationService();
    final status = await NotificationService().requestNotificationPermissions();
    bool isGranted = await NotificationService().requestBatteryPermissions();
    notificationService.showDailyNotification();

    if (authController.isPatient) {
      notificationService.scheduleNotifications();
      notificationService.routineNotifications();
    }
  }

  /*@override
  void initState() {
    super.initState();
    getCurrentUser();
    _requestNotificationPermissions();
  }*/

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

  // bottom Navi logic
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF5DB),
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
                )),
            Container(
              margin: EdgeInsets.all(16),
              child: HomeSchedule(
                schedulesBySelectedDay: schedulesBySelectedDay,
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: HomeRoutine(
                routinesBySelectedDay: routinesBySelectedDay,
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: HomeMemory(),
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
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName; // userName 받음
    //User user = widget.dummy[0]; // user dummy 전달
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
                  text: '${widget.userName}\n',
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
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 24, height: 1.2),
              children: [
                TextSpan(text: '오늘은\n'),
                TextSpan(
                    text: '${now.year}년 ${now.month}월 ${now.day}일 ${weekday}',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                TextSpan(text: ' 이에요.'),
              ],
            ),
          ),
          SizedBox(height: 20),
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
  final int? routineCnt;

  const HomeTodaySummary(
      {Key? key, required this.scheduleCnt, required this.routineCnt})
      : super(key: key);

  @override
  State<HomeTodaySummary> createState() => _HomeTodaySummaryState();
}

class _HomeTodaySummaryState extends State<HomeTodaySummary> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 그림자 색상 및 불투명도 설정
                  spreadRadius: 2, // 그림자의 확산 범위
                  blurRadius: 7, // 그림자의 흐림 정도
                  offset: Offset(2, 2), // 그림자의 위치 (가로, 세로)
                ),
              ], // 테두리 추가
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    TextStyle(color: Colors.black, fontSize: 24, height: 1.5),
                children: [
                  TextSpan(text: '예정된 일정\n'),
                  TextSpan(
                      text: '${widget.scheduleCnt}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFC215))),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 그림자 색상 및 불투명도 설정
                  spreadRadius: 2, // 그림자의 확산 범위
                  blurRadius: 7, // 그림자의 흐림 정도
                  offset: Offset(2, 2), // 그림자의 위치 (가로, 세로)
                ),
              ], // 테두리 추가
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    TextStyle(color: Colors.black, fontSize: 24, height: 1.5),
                children: [
                  TextSpan(text: '오늘의 일과\n'),
                  TextSpan(
                      text: '${widget.routineCnt}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFC215))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 일정이 있어요
// 미완료 스케줄 위젯
class IncompleteScheduleWidget extends StatelessWidget {
  final String? time;
  final String? name;

  const IncompleteScheduleWidget({Key? key, this.time, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xffFFC215),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Color(0xffFFF5DB),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(17),
                  alignment: Alignment.center,
                  child: Text(
                    time ?? '',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(17),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    name ?? '',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//완료 스케줄 위젯
class CompleteScheduleWidget extends StatelessWidget {
  final String? time;
  final String? name;

  const CompleteScheduleWidget({Key? key, this.time, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xffFFC215),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(17),
          color: Color(0xffFFF5DB),
          child: Text('\'$name\' 일정 완료', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}

class HomeSchedule extends StatefulWidget {
  final List<ScheduleModel> schedulesBySelectedDay;

  const HomeSchedule({Key? key, required this.schedulesBySelectedDay})
      : super(key: key);

  @override
  State<HomeSchedule> createState() => _HomeScheduleState();
}

class _HomeScheduleState extends State<HomeSchedule> {
  @override
  Widget build(BuildContext context) {
    List<ScheduleModel> schedules = widget.schedulesBySelectedDay;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '일정이 있어요',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(ScheduleMain());
              },
              child: Text(
                '전체보기',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFC215),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 11),
        schedules.isEmpty // 일정이 없을 때
            ? Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Text(
                  '등록된 일정이 없어요',
                  style: TextStyle(fontSize: 24),
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 17, right: 17, left: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: schedules.length,
                      itemBuilder: (BuildContext context, int index) {
                        ScheduleModel schedule = schedules[index];
                        return schedule.isFinished ?? false
                            ? CompleteScheduleWidget(
                                time: DateFormat('HH시 mm분')
                                    .format(schedule.time!.toDate()),
                                name: schedule.name,
                              )
                            : IncompleteScheduleWidget(
                                time: DateFormat('HH시 mm분')
                                    .format(schedule.time!.toDate()),
                                name: schedule.name,
                              );
                      },
                    )
                  ],
                ),
              ),
      ],
    );
  }
}

// 이 일은 하셨나요? 가로 스크롤
// 루틴 위젯
class RoutineWidget extends StatelessWidget {
  final String? time;
  final String? name;
  final String? url;
  final bool? done;

  const RoutineWidget({Key? key, this.time, this.name, this.url, this.done})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor =
        done == true ? Colors.green : Colors.grey; // done이 true이면 초록색, 아니면 회색
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              url ?? '',
              width: 292,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                time ?? '',
                style: TextStyle(fontSize: 24),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check_circle,
                  color: iconColor,
                ),
              )
            ],
          ),
          Text(
            name ?? '',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

class HomeRoutine extends StatefulWidget {
  final List<RoutineModel> routinesBySelectedDay;

  const HomeRoutine({Key? key, required this.routinesBySelectedDay})
      : super(key: key);

  @override
  State<HomeRoutine> createState() => _HomeRoutineState();
}

class _HomeRoutineState extends State<HomeRoutine> {
  @override
  Widget build(BuildContext context) {
    //User user = widget.dummy[0];
    //List<Routine>? routines = user.routines;
    DateTime _selectedDay = DateTime.now();
    List<RoutineModel> routines = widget.routinesBySelectedDay;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '이 일은 하셨나요?',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                '전체보기',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFC215),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 11),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: routines?.map((routines) {
                    final List<int>? time = routines.time;
                    String formattedTime = '';
                    if (time != null && time.length == 2) {
                      final int hour = time[0];
                      final int minute = time[1];
                      final bool isPM = hour >= 12; // 오후 여부 확인
                      int hour12 = hour > 12 ? hour - 12 : hour;
                      hour12 = hour12 == 0 ? 12 : hour12;
                      formattedTime =
                          '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                    }
                    return RoutineWidget(
                      time: formattedTime,
                      name: routines.name,
                      url: routines.img,
                      // done: routines.isFinished!
                      //     .contains(_selectedDay.toString()),
                      done: true
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ),
      ],
    );
  }
}

class HomeMemory extends StatelessWidget {
  const HomeMemory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        '오늘을 내 기억에 남겨보세요!',
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.left,
      ),
      SizedBox(height: 11),
      Container(
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 66) / 2,
                    height: 260,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://img.freepik.com/premium-photo/happy-woman-sitting-in-the-car-and-traveling-summer-season-on-the-sea-resting-and-special-day-to-vacation_36577-127.jpg'),
                            fit: BoxFit.cover,
                            // 이미지가 Container에 맞게 잘리지 않도록 적절하게 조정
                            opacity: 0.4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        '15일 전\n제주도 여행',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff737373)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 66) / 2,
                    height: 260,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://img.freepik.com/premium-photo/happy-woman-sitting-in-the-car-and-traveling-summer-season-on-the-sea-resting-and-special-day-to-vacation_36577-127.jpg'),
                            fit: BoxFit.cover,
                            // 이미지가 Container에 맞게 잘리지 않도록 적절하게 조정
                            opacity: 0.4),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        '15일 전\n제주도 여행',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff737373)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              '오늘 하루를 보내며서 기억하고 싶은 특별한 순간이 있나요?',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 17,
            ),
            SizedBox(
              width: 380,
              height: 60,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xffFFC215)),
                ),
                onPressed: () {
                  Get.to(MemoryRegister1());
                },
                child: Text(
                  '내 기억에 담기',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      )
    ]);
  }
}
