// 새로운 일정/일과 페이지
import 'package:atti/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
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
  final ColorPallet colorPallet = Get.put(ColorPallet());
  bool isEditMode = false;
  bool isCompletedVisible = false; // 완료된 일과 접기/펼치기 상태 관리

  // 하단바 상태 관리
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

  // 아띠 랜덤 이미지
  Random random = Random();
  String randomImageName = 'EatingStar.png'; // 랜덤 이미지 이름을 저장할 변수

  // 컨트롤러
  final AuthController authController = Get.put(AuthController());
  final RoutineController routineController = Get.put(RoutineController());
  DateTime _selectedDay = DateTime.now(); // 선택한 날짜 !!

  // 일정, 루틴 담는 리스트들
  List<ScheduleModel> schedulesBySelectedDay = []; // 선택된 날짜의 일정들이 반환되는 리스트
  int? numberOfSchedules; // 선택된 날짜의 일정 개수

  List<RoutineModel> routinesBySelectedDay = []; // 선택한 요일의 루틴들
  int? numberOfRoutines;
  String selectedDayInWeek =
      DateFormat('E', 'ko-KR').format(DateTime.now()); // 선택한 날짜의 요일
  String patientName = '';

  @override
  void initState() {
    super.initState();
    randomImageName = imageNames[random.nextInt(imageNames.length)];
    Future.delayed(Duration.zero, () async {
      await _fetchData();
      _makeTTsMessage();
    });
    if (authController.isPatient) {
      patientName = authController.userName.value;
    } else {
      patientName = authController.patientName.value;
    }
    // print("스피치 버블 출력 테스트");
    // print(selectedMessage);

  }

  // 데이터 불러오기
  Future<void> _fetchData() async {

    List<ScheduleModel>? fetchedSchedules =
    await ScheduleService().getSchedulesByDate(_selectedDay);
    List<RoutineModel> fetchedRoutines =
    await RoutineService().getRoutinesByDay(selectedDayInWeek);
    // tts를 위한 오늘의 일정, 일과
    todayRoutines = await RoutineService().getRoutinesByDay(todayInWeek);
    todaySchedules = await ScheduleService().getSchedulesByDate(today);

    setState(() {
      schedulesBySelectedDay = fetchedSchedules;
      numberOfSchedules = schedulesBySelectedDay.length;
    });
  
    setState(() {
      routinesBySelectedDay = fetchedRoutines;
      numberOfRoutines = routinesBySelectedDay.length;
    });
  
    // 보유 중인 알림 요청 검색
    // final List<PendingNotificationRequest> pendingNotificationRequests =
    // await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    //
    // // 반복문으로 각 알림 요청 출력
    // for (var request in pendingNotificationRequests) {
    //   print('Notification ID: ${request.id}');
    //   print('Title: ${request.title}');
    //   print('Body: ${request.body}');
    //   print('Payload: ${request.payload}');
    //   print('-------------------------');
    // }

    // 활성 알림 검색
    // final List<ActiveNotification> activeNotifications =
    // await flutterLocalNotificationsPlugin.getActiveNotifications();
    // print(activeNotifications);
    String? FCMToken = await FirebaseMessaging.instance.getToken();
    print(FCMToken);
  }

  // 아띠 말풍선 메시지 만들기
  Future<void> _makeTTsMessage() async {
    List<String> ttsMessages = [
      '오늘은 어떤 일정이 있으신가요?',
      '일정과 일과를 할 시간이 되면 아띠가 알려드릴게요!'
    ];

    // 오늘 날짜
    DateTime today = DateTime.now();

    // 오늘의 일정 메시지 생성
    if (_selectedDay.year == today.year &&
        _selectedDay.month == today.month &&
        _selectedDay.day == today.day) {
      if (todaySchedules.isNotEmpty) {
        String ttsScheduleMessage = '오늘은 ';
        for (int i = 0; i < todaySchedules.length; i++) {
          ttsScheduleMessage += '${DateFormat('a h시 m분', 'ko_KR')
                  .format(todaySchedules[i].time!.toDate())}에 ${todaySchedules[i].name!}${i == todaySchedules.length - 1 ? ' 일정이 있어요!' : ', '}';
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
          DateTime routineTime = DateTime(
              today.year, today.month, today.day, routineHour, routineMinute);
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
      setState(() {
        selectedMessage = ttsMessages[index];
      });

      await flutterTts.setLanguage('ko-KR');
      await flutterTts.setPitch(1);
      await flutterTts.speak(selectedMessage);
    }
    // print("_makeTTsMessage 함수 안");
    // print(selectedMessage);
  }

  // 날짜 선택 달력
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: _selectedDay,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  //surface: Color(0xffFFF5DB), // 배경 색
                  onSurface: Colors.black, // 달력 숫자 색
                  primary: Color(0xffFFE9B3), // 선택된 영역 색
                  onPrimary: Color(0xffA38130), // 선택된 날짜 숫자 색
                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black // button text color
                        ))),
            child: child!,
          );
        });
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

    // 완료 상태에 따른 일과 필터링
    List<RoutineModel> filteredRoutines = isCompletedVisible
        ? routinesBySelectedDay
        : routinesBySelectedDay
        .where((routine) =>
    routine.isFinished == null ||
        !routine.isFinished!.containsKey(removeZ(
            '${_selectedDay.toString().substring(0, 10)} 00:00:00.000')) ||
        routine.isFinished![removeZ(
            '${_selectedDay.toString().substring(0, 10)} 00:00:00.000')]! == false)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            SizedBox(
              width: width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$patientName님의',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        isEditMode ? '일과 및 일정 편집모드' : '일과 및 일정',
                        textAlign: TextAlign.left,
                        style:
                        const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                        //textScaler: TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                  // 편집모드 버튼
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isEditMode = !isEditMode; // 상태 토글
                      });
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isEditMode ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1
                        )
                      ),
                      child: Icon(
                        isEditMode ? Icons.close : Icons.edit,
                        color: isEditMode ? Colors.black : Colors.white,
                        size: 22,
                      ),
                    ),
                  )
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

            // 아띠 말풍선
            SizedBox(
              width: width * 0.9,
              child: AttiSpeechBubble(
                  comment: isEditMode
                      ? '수정할 내용을 눌러 일과 및 일정을 편집해요'
                      : selectedMessage,
                  color: colorPallet.lightYellow
              ),
            ),
            // Container(
            //   width: width * 0.9,
            //   alignment: Alignment.center,
            //   padding: EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //       color: colorPallet.lightYellow,
            //       borderRadius: BorderRadius.all(Radius.circular(15))),
            //   child: Text(
            //       selectedMessage ?? '',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //           color: colorPallet.black,
            //           fontFamily: 'UhBee',
            //           fontSize: 25)
            //   ),
            // ),

            SizedBox(
              height: height * 0.03,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${DateFormat('yyyy년 M월 d일', 'ko_KR').format(_selectedDay)}\n예정된 일정',
                      textAlign: TextAlign.left,
                      style:
                          const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ),

                  isEditMode
                  ? GestureDetector(
                    onTap: () {
                      Get.to(const ScheduleRegister1());
                    },
                      child: Container(
                        width: width * 0.085,
                        height: width * 0.085,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: width * 0.06,
                        ),
                      )
                  )
                  : TextButton(
                    onPressed: () async {
                      await _selectDate(context);
                      await _fetchData();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                          bottom: 6, left: 15, right: 15, top: 4),
                      minimumSize: const Size(0, 0), // 최소 크기 제거
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      '날짜변경',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: height * 0.05,),

            // 일정 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
            schedulesBySelectedDay.isNotEmpty
                ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: schedulesBySelectedDay.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print('도큐먼트 레퍼런스 해시코드 테스트');
                          print(schedulesBySelectedDay[index].reference!.id.hashCode);
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ScheduleModal(
                                  time: DateFormat('a hh:mm', 'ko_KR').format(
                                      schedulesBySelectedDay[index]
                                          .time!
                                          .toDate()),
                                  location:
                                      schedulesBySelectedDay[index].location!,
                                  name: schedulesBySelectedDay[index].name!,
                                  memo: schedulesBySelectedDay[index].memo,
                                  docRef:
                                      schedulesBySelectedDay[index].reference!,
                                );
                              });
                        },
                        child: ScheduleBox(
                          time: schedulesBySelectedDay[index].time!.toDate(),
                          location: schedulesBySelectedDay[index].location,
                          name: schedulesBySelectedDay[index].name,
                          isFinished: schedulesBySelectedDay[index].isFinished!,
                          docRef: schedulesBySelectedDay[index].reference!,
                          isEditMode: isEditMode,
                          onCompleted: _fetchData,
                        ),
                      );
                    },
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: const Color(0xffDDDDDD))),
                    child: const Text(
                      '등록된 일정이 없어요',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
            const SizedBox(height: 10,),

            // 일과 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      '하루 일과',
                      textAlign: TextAlign.left,
                      style:
                      TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ),
                  isEditMode
                      ? GestureDetector(
                      onTap: () {
                        Get.to(const RoutineRegister1());
                        },
                      child: Container(
                        width: width * 0.085,
                        height: width * 0.085,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: width * 0.06,
                        ),
                      )
                    )
                    : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: 10,),

            // 완료한 일과 접기/펼치기 토글 버튼
            GestureDetector(
              onTap: () {
                setState(() {
                  isCompletedVisible = !isCompletedVisible;
                });
              },
              child: SizedBox(
                width: width * 0.8,
                child: Text(
                  isCompletedVisible ? '완료한 일과 접기' : '완료한 일과 펼치기',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff868686),
                    fontSize: 24,
                  ),
                ),
              ),
            ),

            // 여기에 seletexDay에 해당하는 루틴들을 추가
            //routinesBySelectedDay.length > 0
            filteredRoutines.isNotEmpty
                ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: filteredRoutines.length,
                    itemBuilder: (context, index) {
                      bool isFinished =
                          filteredRoutines[index].isFinished != null &&
                              filteredRoutines[index].isFinished!
                                  .containsKey(removeZ('${_selectedDay.toString().substring(0, 10)} 00:00:00.000')) &&
                              filteredRoutines[index].isFinished![removeZ('${_selectedDay.toString().substring(0, 10)} 00:00:00.000')]!;

                      return GestureDetector(
                        onTap: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (_) {
                          //       return RoutineModal(
                          //         img: routinesBySelectedDay[index].img!,
                          //         name: routinesBySelectedDay[index].name!,
                          //         days:
                          //             routinesBySelectedDay[index].repeatDays!,
                          //         docRef:
                          //             routinesBySelectedDay[index].reference!,
                          //         time: routinesBySelectedDay[index].time!,
                          //         date: _selectedDay,
                          //         onCompleted: _fetchData,
                          //       );
                          //     });
                        },
                        child: RoutineBox2(
                            img: filteredRoutines[index].img!,
                            name: filteredRoutines[index].name!,
                            docRef: filteredRoutines[index].reference!,
                            time: filteredRoutines[index].time!,
                            repeatDays: filteredRoutines[index].repeatDays!,
                            date: _selectedDay,
                            onCompleted: _fetchData,
                            isFinished: isFinished,
                            isEditMode: isEditMode
                        ),
                      );
                    },
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: const Color(0xffDDDDDD))),
                    child: const Text(
                      '예정된 일과가 없어요',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
            SizedBox(
              height: height * 0.01,
            ),
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
