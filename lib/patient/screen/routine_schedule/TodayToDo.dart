import 'package:atti/index.dart';
import 'package:intl/intl.dart';

class TodayToDo extends StatefulWidget {
  const TodayToDo({super.key});

  @override
  State<TodayToDo> createState() => _TodayToDoState();
}

class _TodayToDoState extends State<TodayToDo> {
  final ColorPallet colorPallet = Get.put(ColorPallet());

  // 하단바 상태 관리
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  // 오늘의 일정, 일과 담기
  List<ScheduleModel> schedulesByToday = [];
  List<RoutineModel> routinesByToday = [];

  // 컨트롤러
  final AuthController authController = Get.put(AuthController());
  final RoutineController routineController = Get.put(RoutineController());
  String patientName = '';

  // 데이터 불러오기
  Future<void> _fetchData() async {
    List<ScheduleModel>? fetchedSchedules =
        await ScheduleService().getSchedulesByDate(DateTime.now());
    List<RoutineModel> fetchedRoutines = await RoutineService()
        .getRoutinesByDay(DateFormat('E', 'ko-KR').format(DateTime.now()));

    if (fetchedSchedules != null) {
      setState(() {
        schedulesByToday = fetchedSchedules;
      });
    } else {
      setState(() {
        schedulesByToday = [];
      });
    }

    if (fetchedRoutines != null) {
      setState(() {
        routinesByToday = fetchedRoutines;
      });
    } else {
      setState(() {
        routinesByToday = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchData();
    });

    if (authController.isPatient) {
      patientName = authController.userName.value;
    } else {
      patientName = authController.patientName.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // 현재 시간 이후의 가장 가까운 루틴 찾기
    RoutineModel? nextRoutine;
    final now = DateTime.now();

    // 현재 시간과 비교하기 위해 routinesByToday를 DateTime으로 변환하여 정렬
    routinesByToday.sort((a, b) {
      final DateTime aTime =
          DateTime(now.year, now.month, now.day, a.time![0], a.time![1]);
      final DateTime bTime =
          DateTime(now.year, now.month, now.day, b.time![0], b.time![1]);

      return aTime.compareTo(bTime);
    });

    // 현재 시간 이후의 첫 번째 루틴 찾기
    nextRoutine = routinesByToday.firstWhere(
      (routine) {
        final DateTime routineTime = DateTime(
            now.year, now.month, now.day, routine.time![0], routine.time![1]);
        return routineTime.isAfter(now);
      },
      orElse: () => routinesByToday[0], // 없을 경우 그냥 첫번째 루틴 반환
    );

    // [7, 30] -> 오전 7:30 형식으로 변환
    String formattedTime = '';
    if (nextRoutine.time != null && nextRoutine.time!.length == 2) {
      final int hour = nextRoutine.time![0];
      final int minute = nextRoutine.time![1];
      final bool isPM = hour >= 12; // 오후 여부 확인
      int hour12 = hour > 12 ? hour - 12 : hour;
      hour12 = hour12 == 0 ? 12 : hour12;
      formattedTime =
          '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    // 최상단 텍스트 생성
    String getTopText() {
      if (nextRoutine!.time != null && nextRoutine.time!.length == 2) {
        final int routineHour = nextRoutine.time![0];
        final int routineMinute = nextRoutine.time![1];

        final DateTime routineTime = DateTime.now().copyWith(
          hour: routineHour,
          minute: routineMinute,
        );

        final Duration difference = routineTime.difference(DateTime.now());

        if (difference.inMinutes <= 5 && difference.inMinutes >= 0) {
          return '지금 일과를 하셔야 해요';
        } else if (difference.inMinutes > 5) {
          int hours = difference.inHours;
          int minutes = difference.inMinutes % 60; // 남은 분 계산

          if (hours > 0) {
            return '${hours}시간 ${minutes}분 뒤 일과가 있어요';
          } else {
            return '${minutes}분 뒤 일과가 있어요';
          }
        }
      }
      return '오늘은 일과가 없어요!'; // 기본 메시지
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.06,
            ),

            // 최상단 텍스트
            Center(
              child: SizedBox(
                width: width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patientName}님',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      getTopText(),
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: width * 0.05,
            ),

            // 날짜
            Text(
              DateFormat('yyyy년 M월 d일', 'ko_KR').format(DateTime.now()),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: width * 0.01,
            ),

            // 일과 시간
            Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    color: colorPallet.lightYellow,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 1)),
                child: Text(
                  formattedTime,
                  style: TextStyle(fontSize: 24),
                )),
            SizedBox(
              height: width * 0.05,
            ),

            // 일과 사진
            Container(
              alignment: Alignment.center,
              width: width * 0.68,
              height: width * 0.68,
              child: Container(
                child: ClipOval(
                  child: Image.network(
                    nextRoutine.img!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: width * 0.03,
            ),

            // 일과 이름
            Text(
              nextRoutine.name!,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: width * 0.04,
            ),

            // 일과 이름 하단 버튼
            Container(
                width: width * 0.8,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Color(0xffFFE7A4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '시간이 되면 알려드릴게요',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                )),
            SizedBox(
              height: width * 0.06,
            ),
            Container(
              width: width * 0.83,
              height: 1,
              color: colorPallet.grey,
            ),
            SizedBox(
              height: width * 0.06,
            ),

            // 일정 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
            Center(
              child: SizedBox(
                width: width * 0.83,
                child: Text(
                  '오늘의 일정',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            schedulesByToday.length > 0
                ? ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: schedulesByToday.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return ScheduleModal(
                                  time: DateFormat('a hh:mm', 'ko_KR').format(
                                      schedulesByToday[index].time!.toDate()),
                                  location: schedulesByToday[index].location!,
                                  name: schedulesByToday[index].name!,
                                  memo: schedulesByToday[index].memo,
                                  docRef: schedulesByToday[index].reference!,
                                );
                              });
                        },
                        child: ScheduleBox(
                          time: DateFormat('a hh:mm', 'ko_KR')
                              .format(schedulesByToday[index].time!.toDate()),
                          location: schedulesByToday[index].location,
                          name: schedulesByToday[index].name,
                          isFinished: schedulesByToday[index].isFinished!,
                          docRef: schedulesByToday[index].reference!,
                          isEditMode: false,
                          onCompleted: _fetchData,
                        ),
                      );
                    },
                  )
                : Container(
                    margin: EdgeInsets.only(top: 15),
                    width: MediaQuery.of(context).size.width * 0.83,
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: Color(0xffDDDDDD))),
                    child: Text(
                      '등록된 일정이 없어요',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
            SizedBox(height: width * 0.05,),

            // 일과
            Center(
              child: SizedBox(
                width: width * 0.83,
                child: Text(
                  '다음 일과는?',
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),



          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
