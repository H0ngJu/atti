// 새로운 일정/일과 페이지
import 'package:atti/commons/CarerRoutineModal.dart';
import 'package:atti/index.dart';
import 'package:intl/intl.dart';

class CarerRoutineScheduleMain extends StatefulWidget {
  const CarerRoutineScheduleMain({super.key});

  @override
  State<CarerRoutineScheduleMain> createState() => _CarerRoutineScheduleMainState();
}

class _CarerRoutineScheduleMainState extends State<CarerRoutineScheduleMain> {
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
  // FlutterTts flutterTts = FlutterTts();
  // String ttsMsg = '';
  // String selectedMessage = '';
  List<RoutineModel> todayRoutines = [];
  List<ScheduleModel> todaySchedules = [];
  DateTime today = DateTime.now();
  String todayInWeek = DateFormat('E', 'ko-KR').format(DateTime.now());

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
    //randomImageName = imageNames[random.nextInt(imageNames.length)];
    Future.delayed(Duration.zero, () async {
      await _fetchData();
    });
    if (authController.isPatient) {
      patientName = authController.userName.value;
    } else {
      patientName = authController.patientName.value;
    }
    // print("스피치 버블 출력 테스트");
    // print(selectedMessage);
    print("환자 도큐먼트 레퍼런스 출력 테스트");
    print(authController.patientDocRef!.path);
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

    RoutineModel? nextRoutine;
    // 현재 날짜 문자열 생성
    final todayKey = removeZ('${DateTime.now().toString().substring(0, 10)} 00:00:00.000');

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

    final now = DateTime.now();
    // 완료 여부와 현재 시간 조건 추가하여 루틴 정렬
    routinesBySelectedDay.sort((a, b) {
      final DateTime aTime =
      DateTime(now.year, now.month, now.day, a.time![0], a.time![1]);
      final DateTime bTime =
      DateTime(now.year, now.month, now.day, b.time![0], b.time![1]);

      return aTime.compareTo(bTime);
    });

    // 현재 시간 이후의 완료되지 않은 첫 번째 루틴 찾기
    nextRoutine = routinesBySelectedDay.isNotEmpty
        ? routinesBySelectedDay.firstWhere(
          (routine) {
        final DateTime routineTime = DateTime(
            now.year, now.month, now.day, routine.time![0], routine.time![1]);

        // 완료 여부 확인
        final bool isFinished = routine.isFinished != null &&
            routine.isFinished!.containsKey(todayKey) &&
            routine.isFinished![todayKey]!;

        return routineTime.isAfter(now) && !isFinished;
      },
      orElse: () => routinesBySelectedDay.first, // 첫 번째 루틴 반환
    )
        : null; // 루틴이 없을 경우 null로 설정

    // [7, 30] -> 오전 7:30 형식으로 변환
    String formatRoutineTime(List<int>? time) {
      if (time != null && time.length == 2) {
        final int hour = time[0];
        final int minute = time[1];
        final bool isPM = hour >= 12; // 오후 여부 확인
        int hour12 = hour > 12 ? hour - 12 : hour;
        hour12 = hour12 == 0 ? 12 : hour12;
        return '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      } else {
        return '로딩중이에요...';
      }
    }

    // 다음 일과까지 남은 시간 계산
    String getBtnText() {
      if (nextRoutine != null && nextRoutine.time != null && nextRoutine.time!.length == 2) {
        final int routineHour = nextRoutine.time![0];
        final int routineMinute = nextRoutine.time![1];
        final DateTime routineTime = DateTime.now().copyWith(
          hour: routineHour,
          minute: routineMinute,
        );

        final Duration difference = routineTime.difference(DateTime.now());

        if (difference.inMinutes >= 0) {
          int hours = difference.inHours;
          int minutes = difference.inMinutes % 60; // 남은 분 계산

          if (hours > 0) {
            return '$hours시간 $minutes분 뒤 일과가 있어요';
          } else {
            return '$minutes분 뒤 일과가 있어요';
          }
        }
      }
      return '오늘 남은 일과가 없어요!'; // 기본 메시지
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.06,
            ),
            Center(
              child: SizedBox(
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
                          isEditMode ? '일과 및 일정 편집모드' : '현재 일과 및 일정',
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
            ),

            if (!isEditMode) ...[
              SizedBox(height: height * 0.03),
              // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
              // 날짜
              Text(
                DateFormat('yyyy년 M월 d일', 'ko_KR').format(DateTime.now()),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: width * 0.01,),

              // 일과 시간
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      color: colorPallet.lightYellow,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Text(
                    nextRoutine != null
                        ? formatRoutineTime(nextRoutine.time)
                        : '다음 일과 없음',
                    style: const TextStyle(fontSize: 24),
                  )),
              SizedBox(height: width * 0.05,),

              // 일과 사진
              Container(
                alignment: Alignment.center,
                width: width * 0.68,
                height: width * 0.68,
                child: Container(
                  child: ClipOval(
                    child: nextRoutine != null && nextRoutine.img != null
                        ? Image.network(
                      nextRoutine.img!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    )
                        : Container(),
                  ),
                ),
              ),
              SizedBox(height: width * 0.03,),

              // 일과 이름
              Text(
                nextRoutine?.name ?? '로딩중이에요...',
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
              SizedBox(height: width * 0.04,),

              // 일과 이름 하단 버튼
              Container(
                  width: width * 0.85,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFE7A4),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    getBtnText(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  )),
              // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
            ],

            SizedBox(height: height * 0.03,),
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
                      backgroundColor: colorPallet.lightGrey,
                    ),
                    child: const Text(
                      '날짜변경',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
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
                          //time: DateFormat('a hh:mm', 'ko_KR').format(schedulesBySelectedDay[index].time!.toDate()),
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
                          showDialog(
                              context: context,
                              builder: (_) {
                                return CarerRoutineModal(
                                  name: filteredRoutines[index].name!,
                                  isFinished: filteredRoutines[index].isFinished!
                                );
                              });
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
