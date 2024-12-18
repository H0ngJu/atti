import 'dart:math';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/Notice/FullScreenRoutine.dart';
import 'package:atti/tmp/screen/Notice/FullScreenSchedule1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../data/auth_controller.dart';
import '../../data/notification/notification.dart';
import '../../data/routine/routine_model.dart';
import '../../data/routine/routine_service.dart';
import '../../data/schedule/schedule_model.dart';
import '../../data/schedule/schedule_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'Notice/FullScreenSchedule2.dart';
import 'Notice/FullScreenSchedule3.dart';

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
  String weatherStatus = '';
  final List<String> defaultImg = [
    'lib/assets/Atti/standingAtti.png',
    'lib/assets/Atti/Coffee.png',
    'lib/assets/Atti/EatingStar.png',
    'lib/assets/Atti/Napping.png',
    'lib/assets/Atti/Normal.png',
    'lib/assets/Atti/ReadingBook.png',
    'lib/assets/Atti/Soccer.png',
    'lib/assets/Atti/Stars.png',
    'lib/assets/Atti/Walking.png',
  ];
  final List<String> topImg = [];
  late String selectedImage = '';

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
    //selectedImage = updateImagesBasedOnWeather(weatherStatus);
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
            MaterialPageRoute(
                builder: (context) =>
                    FullScreenSchedule(docRef: docRef)), // ScheduleMain 페이지로 이동
          );
        } else if (payload.startsWith('/schedule2/')) {
          String docRef = payload.substring('/schedule2/'.length);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FullScreenSchedule2(docRef: docRef)),
          );
        } else if (payload.startsWith('/schedule3/')) {
          String docRef = payload.substring('/schedule3/'.length);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FullScreenSchedule3(docRef: docRef)),
          );
        } else if (payload.startsWith('/routine/')) {
          String docRef = payload.substring('/routine/'.length);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FullScreenRoutine(docRef: docRef)), // RoutineMain 페이지로 이동
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
      //notificationService.scheduleNotifications();
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
      '오늘은 ${_selectedDay.year}년 ${_selectedDay.month}월 ${_selectedDay
          .day}일 ${weekday}이에요',
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
      weatherStatus = data['weather'][0]['description'];
      print("weather " + weatherStatus);
      selectedImage = updateImagesBasedOnWeather(weatherStatus);
      final weatherTranslation =
      weatherTranslations[weatherStatus.toLowerCase()];
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

  // 날씨와 계절에 따라 이미지 리스트를 업데이트하고 랜덤 이미지를 반환하는 함수
  String updateImagesBasedOnWeather(String weatherStatus) {
    // 계절 이미지를 가져옵니다.
    String seasonImage = getSeason();

    print("1 " + weatherStatus);
    // 날씨에 따라 특정 이미지를 추가합니다.
    if (weatherStatus.contains('rain') || weatherStatus.contains('mist') ||
        weatherStatus.contains('drizzel')) {
      topImg.add('lib/assets/Atti/rainy.png');
    }
    if (weatherStatus.contains('clear')) {
      topImg.add('lib/assets/Atti/sunny.png');
    }

    // 계절 이미지를 추가합니다.
    topImg.add('lib/assets/Atti/$seasonImage');

    // 기본 이미지 리스트에 topImg 리스트를 추가합니다.
    List<String> updatedImgList = List.from(defaultImg)
      ..addAll(topImg);
    print("here" + '${updatedImgList}');
    // 업데이트된 리스트에서 랜덤 이미지를 선택합니다.
    final random = Random();
    int index = random.nextInt(updatedImgList.length);
    return updatedImgList[index];
  }

  String getSeason() {
    int month = DateTime
        .now()
        .month; // 현재 월을 가져옵니다.
    if (month >= 3 && month <= 5) {
      return 'spring.png';
    } else if (month >= 6 && month <= 8) {
      return 'summer.png';
    } else if (month >= 9 && month <= 11) {
      return 'autumn.png';
    } else {
      return 'winter.png';
    }
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

  // bottom Navi logic
  int _selectedIndex = 1;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
              )
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: HomePatientTop(
                  userName: authController.userName.value,
                  selectedImage: selectedImage,
                )),
          //   Container(
          //     margin: EdgeInsets.all(16),
          //     child: HomeRoutine(
          //       routinesBySelectedDay: routinesBySelectedDay,
          //     ),
          //   ),
          //   Container(
          //     margin: EdgeInsets.all(16),
          //     child: HomeSchedule(
          //       schedulesBySelectedDay: schedulesBySelectedDay,
          //     ),
          //   ),
          //   Container(
          //     margin: EdgeInsets.all(16),
          //     child: HomeMemory(),
          //   )
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
  final String selectedImage;

  const HomePatientTop(
      {Key? key, required this.userName, required this.selectedImage})
      : super(key: key);

  @override
  State<HomePatientTop> createState() => _HomePatientTopState();
}

class _HomePatientTopState extends State<HomePatientTop> {
  final AuthController authController = Get.put(AuthController());
  final List<String> greetingMsg = [
    '안녕하세요',
    '만나서 반가워요!',
    '오늘 하루 아띠와 함께해요!',
    '잘 주무셨나요?'
  ];
  late final int index; // `late` 키워드를 사용하여 나중에 초기화됨을 명시
  //late String _selectedImage;
  //String _weatherStatus = '';

  @override
  void initState() {
    super.initState();
    final Random random = Random();
    index = random.nextInt(greetingMsg.length); // 여기에서 `index` 초기화
    //_selectedImage = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    String userName = widget.userName; // userName 받음
    //User user = widget.dummy[0]; // user dummy 전달
    // 시간 가져오기
    DateTime now = DateTime.now();
    String weekday = _getWeekday(now.weekday);
    // String formattedTime = DateFormat('a h시 mm분이에요', 'ko_KR').format(now);
    ColorPallet _colorPallet = ColorPallet();

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 열을 위에서부터 시작하도록 정렬
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.black,
                      height: 1.2,
                      fontFamily: 'PretendardRegular'),
                  children: [
                    TextSpan(
                      text: '${widget.userName}님\n',
                      style:
                      TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
                    ),
                    TextSpan(
                      text: '만나서 반가워요!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'PretendardSemiBold'),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 다른 페이지로 이동하는 코드
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => YourNextPage()), // YourNextPage를 원하는 페이지로 변경
                  // );
                },
                child: Container(
                  width: 45, // 버튼의 너비
                  height: 45, // 버튼의 높이
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '나',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 14), //
          Center(
            child: Text(
              '오늘은요',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'UhBee', fontSize: 25)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              widget.selectedImage.isNotEmpty // selectedImage가 비어있지 않다면 이미지를 표시
                  ? Image(
                image: AssetImage(widget.selectedImage),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.55,
              )
                  : Container(
                // selectedImage가 비어있거나 로딩 중일 때
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.55,
                height: MediaQuery
                    .of(context)
                    .size
                    .width *
                    0.55, // 이미지와 동일한 비율로 설정
                child: Center(
                  child: CircularProgressIndicator(), // 로딩 인디케이터 표시
                ),
              ),
            ],
          ),
          SizedBox(height: 10), // 간격을 추가하여 이미지와 텍스트를 구분
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
                '${now.year}년\n${now.month}월 ${now.day}일 ${weekday}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'UhBee', fontSize: 25)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    // 첫 번째 버튼 클릭 시 동작
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black, // 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 모서리 둥글기
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '지금 할 일을 알려줘',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16), // 버튼 사이의 간격
                TextButton(
                  onPressed: () {
                    // 두 번째 버튼 클릭 시 동작
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: _colorPallet.goldYellow, // 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 모서리 둥글기
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '기억 대화를 나눌래',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 30),
          // Container(
          //   child: Text(
          //     '${formattedTime}',
              // style: TextStyle(fontSize: 30, fontFamily: 'PretendardMedium'),
              // textAlign: TextAlign.left,
            // ),
          // )
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

// 사용하지 않는 위젯
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
