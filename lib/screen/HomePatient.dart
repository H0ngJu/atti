import 'dart:ffi';
import 'dart:math';
import 'package:atti/commons/AttiAppBar.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/screen/Notice/FullScreenRoutine.dart';
import 'package:atti/screen/Notice/FullScreenSchedule1.dart';
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:atti/screen/routine/RoutineMain.dart';
import 'package:atti/screen/schedule/ScheduleMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../commons/RoutineModal.dart';
import '../commons/ScheduleModal.dart';
import '../data/auth_controller.dart';
import '../data/memory/memory_note_controller.dart';
import '../data/memory/memory_note_model.dart';
import '../data/memory/memory_note_service.dart';
import '../data/notification/notification.dart';
import '../data/routine/routine_model.dart';
import '../data/routine/routine_service.dart';
import '../data/schedule/schedule_model.dart';
import '../data/schedule/schedule_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'Notice/FullScreenSchedule2.dart';

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
  String _weatherDescription = '';
  FlutterTts flutterTts = FlutterTts();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndSpeakWeather();
    });
    listenNotifications();
  }

  // 푸시 알림 스트림 리슨
  void listenNotifications() {
    NotificationService().streamController.stream.listen((String? payload) {
      if (payload != null) {
        print('@@@@@@@@@Received payload: $payload');
        if (payload.startsWith('/schedule1/')) {
          String docRef = payload.substring('/schedule1/'.length);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FullScreenSchedule(docRef: docRef)), // ScheduleMain 페이지로 이동
          );
        } else if (payload.startsWith('/schedule2/')) {
          String docRef = payload.substring('/schedule2/'.length);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FullScreenSchedule2(docRef: docRef)),
          );
        } else if (payload.startsWith('/routine/')) {
          String docRef = payload.substring('/routine/'.length);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FullScreenRoutine(docRef: docRef)), // RoutineMain 페이지로 이동
          );
        }
      }
    });
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

  Future<void> _fetchAndSpeakWeather() async {

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
    String weekday = _getWeekday(_selectedDay.weekday);
    final List<String> greetings = [
      '안녕하세요',
      '오늘의 ${_selectedDay.year}년 ${_selectedDay.month}월 ${_selectedDay.day}일 ${weekday}이에요',
      '오늘의 기분은 어떠신가요?',
      '내 기억에서 과거 기억을 열람해볼까요?',
      '오늘의 일정을 확인해보세요',
      '오늘의 일과를 확인해보세요',
    ];

    final Map<String, String> weatherTranslations = {
      'thunderstorm with light rain': '가벼운 비를 동반한 천둥구름',
      'thunderstorm with rain': '비를 동반한 천둥구름',
      'thunderstorm with heavy rain': '폭우를 동반한 천둥구름',
      'light thunderstorm': '약한 천둥구름',
      'thunderstorm': '천둥구름',
      'heavy thunderstorm': '강한 천둥구름',
      'ragged thunderstorm': '불규칙적 천둥구름',
      'thunderstorm with light drizzle': '약한 연무를 동반한 천둥구름',
      'thunderstorm with drizzle': '연무를 동반한 천둥구름',
      'thunderstorm with heavy drizzle': '강한 안개비를 동반한 천둥구름',
      'light intensity drizzle': '가벼운 안개비',
      'drizzle': '안개비',
      'heavy intensity drizzle': '강한 안개비',
      'light intensity drizzle rain': '가벼운 적은비',
      'drizzle rain': '적은비',
      'heavy intensity drizzle rain': '강한 적은비',
      'shower rain and drizzle': '소나기와 안개비',
      'heavy shower rain and drizzle': '강한 소나기와 안개비',
      'shower drizzle': '소나기',
      'light rain': '약한 비',
      'moderate rain': '중간 비',
      'heavy intensity rain': '강한 비',
      'very heavy rain': '매우 강한 비',
      'extreme rain': '극심한 비',
      'freezing rain': '우박',
      'light intensity shower rain': '약한 소나기 비',
      'shower rain': '소나기 비',
      'heavy intensity shower rain': '강한 소나기 비',
      'ragged shower rain': '불규칙적 소나기 비',
      'light snow': '가벼운 눈',
      'snow': '눈',
      'heavy snow': '강한 눈',
      'sleet': '진눈깨비',
      'shower sleet': '소나기 진눈깨비',
      'light rain and snow': '약한 비와 눈',
      'rain and snow': '비와 눈',
      'light shower snow': '약한 소나기 눈',
      'shower snow': '소나기 눈',
      'heavy shower snow': '강한 소나기 눈',
      'mist': '박무',
      'smoke': '연기',
      'haze': '연무',
      'sand, dust whirls': '모래 먼지',
      'fog': '안개',
      'sand': '모래',
      'dust': '먼지',
      'volcanic ash': '화산재',
      'squalls': '돌풍',
      'tornado': '토네이도',
      'clear sky': '구름 한 점 없는 맑은 하늘',
      'few clouds': '약간의 구름이 낀 하늘',
      'scattered clouds': '드문드문 구름이 낀 하늘',
      'broken clouds': '구름이 거의 없는 하늘',
      'overcast clouds': '구름으로 뒤덮인 흐린 하늘',
      'tropical storm': '태풍',
      'hurricane': '허리케인',
      'cold': '한랭',
      'hot': '고온',
      'windy': '바람부는',
      'hail': '우박',
      'calm': '바람이 거의 없는',
      'light breeze': '약한 바람',
      'gentle breeze': '부드러운 바람',
      'moderate breeze': '중간 세기 바람',
      'fresh breeze': '신선한 바람',
      'strong breeze': '센 바람',
      'high win': '돌풍에 가까운 센 바람',
      'gale': '돌풍',
      'severe gale': '심각한 돌풍',
      'storm': '폭풍',
      'violent storm': '강한 폭풍',
      'tornado': '토네이도',
    };

    await dotenv.load();
    final tmpapiKey = dotenv.env['OPEN_WEATHER_MAP_API_KEY'];

    if (tmpapiKey == null) {
      print('환경 변수 WEATHER_API_KEY를 찾을 수 없습니다.');
      return;
    }

    final city = 'Seoul';
    final url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$tmpapiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final description = data['weather'][0]['description'];
      final temperature = data['main']['temp'];
      final humidity = data['main']['humidity'];
      final weatherStatus = data['weather'][0]['description'];
      final weatherTranslation = weatherTranslations[weatherStatus.toLowerCase()];
      setState(() {
        if (weatherTranslation != null) {
          _weatherDescription =
          '현재 날씨는 $weatherTranslation이며, 온도는 $temperature도, 습도는 $humidity% 입니다.';
        } else {
          // 만약 매핑된 한글이 없는 경우에는 영어로
          _weatherDescription =
          '현재 날씨는 $description이며, 온도는 $temperature도, 습도는 $humidity% 입니다.';
        }
      });
    } else {
      throw Exception('Failed to load weather');
    }

    greetings.add(_weatherDescription);

    final Random random = Random();
    final index = random.nextInt(greetings.length);

    String message = greetings[index];

    await flutterTts.setLanguage('ko-KR');
    await flutterTts.setPitch(1);
    await flutterTts.speak(message);
  }
  /*Future<void> _speakWeather() async {
    await flutterTts.setLanguage('ko-KR');
    await flutterTts.setPitch(1);
    await flutterTts.speak(_weatherDescription);
  }*/

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
                  text: '${widget.userName}님\n',
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
            //height: 132,
            // 정적으로 고정할 것인가?
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(vertical: 25),
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
            //height: 132,
            // 정적으로 고정할 것인가?
            margin: EdgeInsets.only(left: 8),
            padding: EdgeInsets.symmetric(vertical: 25),
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
  final String time;
  final String name;
  final String location;
  final String memo;
  final DocumentReference docRef;

  const IncompleteScheduleWidget({Key? key, required this.time, required this.name, required this.location, required this.memo, required this.docRef})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (_) {
          return ScheduleModal(
            time: time,
            location: location,
            name: name,
            memo: memo,
            docRef: docRef,
          );
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color(0xffFFC215),
            width: 2,
          ),
        ),
      child : Row(
            children: [
              Expanded(
                child: Container(
                  decoration : BoxDecoration( color: Color(0xffFFF5DB),borderRadius: BorderRadius.circular(15),),
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
                  decoration : BoxDecoration( color: Colors.white,borderRadius: BorderRadius.circular(15),),
                  child: Text(
                    name ?? '',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              ],
            ),
      ),
    );
  }
}

//완료 스케줄 위젯
class CompleteScheduleWidget extends StatelessWidget {
  final String time;
  final String name;
  final String location;
  final String memo;
  final DocumentReference docRef;

  const CompleteScheduleWidget({Key? key, required this.time, required this.name, required this.location, required this.docRef, required this.memo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (_) {
          return ScheduleModal(
            time: time,
            location: location,
            name: name,
            memo: memo,
            docRef: docRef,
          );
        });
      },
      child: Container(
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
                                name: schedule.name!,
                                location: schedule.location!,
                                memo: schedule.memo ?? '',
                                docRef: schedule.reference!,
                              )
                            : IncompleteScheduleWidget(
                                time: DateFormat('HH시 mm분')
                                    .format(schedule.time!.toDate()),
                                name: schedule.name!,
                                location: schedule.location!,
                                memo: schedule.memo ?? '',
                                docRef: schedule.reference!,
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
  final List<String>? days;
  final date;
  final DocumentReference? docRef;
  final List<int>? originalTime;

  const RoutineWidget({Key? key, this.time, this.name, this.url, this.done, this.days, this.docRef, this.date, this.originalTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor =
        done == true ? Colors.green : Colors.grey; // done이 true이면 초록색, 아니면 회색
    return GestureDetector(
      onTap: (){
        showDialog(context: context, builder: (_) {
          return RoutineModal(
            img: url!,
            name: name!,
            days: days!,
            docRef: docRef!,
            date: date,
            time: originalTime!,
            onCompleted: (){},
          );
        });
      },
      child: Container(
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
                  onPressed: () {print('done: $done');},
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
  DateTime _selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    //User user = widget.dummy[0];
    //List<Routine>? routines = user.routines;
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
              onPressed: () {
                Get.to(RoutineMain());
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
                    // isFinished가 true인지 확인하여 해당하는 값으로 설정

                    bool isFinished = routines.isFinished != null &&
                        routines.isFinished!.containsKey(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000') &&
                        routines.isFinished![_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000']!;
                    //print('${routines.isFinished}');
                    return RoutineWidget(
                      time: formattedTime,
                      name: routines.name,
                      url: routines.img,
                      done: isFinished,
                      // done: routines.isFinished![_selectedDay.toString().replaceAll('Z', '')]! ?? false,
                      days: routines.repeatDays,
                      date: DateTime.now().toString(),
                      docRef: routines.reference,
                      originalTime: routines.time
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

class HomeMemory extends StatefulWidget {
  const HomeMemory({Key? key}) : super(key: key);

  @override
  _HomeMemoryState createState() => _HomeMemoryState();
}

class _HomeMemoryState extends State<HomeMemory> {
  MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  MemoryNoteService memoryNoteService = MemoryNoteService();
  List<MemoryNoteModel> memoryNotes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<MemoryNoteModel> fetchedNotes =
    await memoryNoteService.getMemoryNote();

    setState(() {
      memoryNotes = fetchedNotes;
    });
  }

  MemoryNoteModel getRandomMemoryNote() {
    if (memoryNotes.isEmpty) return MemoryNoteModel(); // Return empty model if list is empty
    final Random random = Random();
    final int randomIndex = random.nextInt(memoryNotes.length);
    return memoryNotes[randomIndex];
  }

  @override
  @override
  Widget build(BuildContext context) {
    final MemoryNoteModel randomMemoryNote = getRandomMemoryNote();

    return Column(
      children: [
        Text(
          '오늘을 내 기억에 남겨보세요!',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 11),
        Container(
          padding: EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              randomMemoryNote.img != null
                  ? Row(
                children: [
                  Expanded(
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 66) / 2,
                      height: 260,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('${randomMemoryNote.img}'),
                          fit: BoxFit.cover,
                          opacity: 0.4,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          '${randomMemoryNote.imgTitle}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff737373),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Text(
                '저장된 기억이 없어요',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff737373),
                  ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}