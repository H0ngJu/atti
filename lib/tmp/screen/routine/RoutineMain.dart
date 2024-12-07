// 하루 일과 메인 화면
import 'package:atti/tmp/screen/routine/register/RoutineRegister1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import '../../../commons/BottomNextButton.dart';
import '../../../commons/RoutineBox.dart';
import '../../../commons/RoutineModal.dart';
import '../../../data/auth_controller.dart';
import '../../../data/routine/routine_controller.dart';
import '../../../data/routine/routine_model.dart';
import '../../../data/routine/routine_service.dart';

class RoutineMain extends StatefulWidget {
  const RoutineMain({super.key});

  @override
  State<RoutineMain> createState() => _RoutineMainState();
}

class _RoutineMainState extends State<RoutineMain> {
  final RoutineController routineController = Get.put(RoutineController());
  final AuthController authController = Get.put(AuthController());

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  List<RoutineModel> routinesBySelectedDay = [];
  int? numberOfRoutines;
  String selectedDayInWeek = DateFormat('E', 'ko-KR').format(DateTime.now());

  String removeZ(String dateTimeString) {
    return dateTimeString.replaceAll('Z', '');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    List<RoutineModel> fetchedRoutines =
        await RoutineService().getRoutinesByDay(selectedDayInWeek);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                '${authController.userName.value}님의',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text(
                '하루 일과',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 30),
            RoutineCalendar(),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color(0xffFFFAEF),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(_selectedDay),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  numberOfRoutines != null && numberOfRoutines! >= 1
                      ? RoutineTimeline()
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          child: Text(
                            '오늘은 일과가 없네요!',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  NextButton(
                    next: RoutineRegister1(),
                    content: '하루 일과 등록하기',
                    isEnabled: true,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget RoutineCalendar() {
    return TableCalendar(
      locale: 'ko-KR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) async {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          //print(_selectedDay.toString());
          selectedDayInWeek = DateFormat('E', 'ko-KR').format(_selectedDay);
          //print(_selectedDay);
        });
        await _fetchData();
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      availableGestures: AvailableGestures.horizontalSwipe,
      headerVisible: false,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(color: Color(0xff737373), fontSize: 20),
        weekendTextStyle: TextStyle(color: Color(0xff737373), fontSize: 20),
        todayTextStyle: TextStyle(color: Color(0xff737373), fontSize: 20),
        selectedDecoration: BoxDecoration(
          color: Color(0xffFFC215),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xffFFC215), width: 1.5)),
      ),
    );
  }

  Widget RoutineTimeline() {
    return Container(
      height: numberOfRoutines != null && numberOfRoutines! <= 1
          ? MediaQuery.of(context).size.height * 0.6
          : (numberOfRoutines != null
              ? numberOfRoutines! * MediaQuery.of(context).size.height * 0.55
              : 0),
      width: MediaQuery.of(context).size.width * 0.9,
      child: TimelineTheme(
        data: TimelineThemeData(
            nodePosition: 0,
            indicatorPosition: 0,
            color: Color(0xffFFC215),
            connectorTheme: ConnectorThemeData(
                color: Color(0xff9C9C9C), indent: 5, thickness: 1.5),
            indicatorTheme: IndicatorThemeData(
              size: 17,
            )),
        child: Timeline.tileBuilder(
          builder: TimelineTileBuilder.connectedFromStyle(
            indicatorStyleBuilder: (context, index) {
              //print('${routinesBySelectedDay[index].name} : ${routinesBySelectedDay[index].isFinished![removeZ(_selectedDay.toString())]}');
              bool isFinished =
                  routinesBySelectedDay[index].isFinished != null &&
                      routinesBySelectedDay[index]
                          .isFinished!
                          .containsKey(removeZ(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000')) &&
                      routinesBySelectedDay[index]
                          .isFinished![removeZ(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000')]!;
              //print('here : ${isFinished}');
              return (isFinished
                  ? IndicatorStyle.dot
                  : IndicatorStyle.outlined);
            },
            //connectorStyle: ConnectorStyle.dashedLine,
            connectorStyleBuilder: (context, index) =>
                ConnectorStyle.dashedLine,
            lastConnectorStyle: ConnectorStyle.dashedLine,
            contentsAlign: ContentsAlign.basic,
            //indicatorStyle: IndicatorStyle.dot,
            contentsBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),

              // 각 타임라인 타일
              child: GestureDetector(
                onTap: () {
                  // 타일 클릭 시 모달창
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (
                routinesBySelectedDay[index].isFinished != null &&
                routinesBySelectedDay[index]
                        .isFinished!
                        .containsKey(removeZ(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000')) &&
                routinesBySelectedDay[index]
                    .isFinished![removeZ(_selectedDay.toString().substring(0, 10)+ ' 00:00:00.000')]!)
                          ? '완료됨'
                          : '완료되지 않음',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xff737373),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RoutineBox(
                      time: routinesBySelectedDay[index].time!,
                      img: routinesBySelectedDay[index].img!,
                      name: routinesBySelectedDay[index].name!,
                      days: routinesBySelectedDay[index].repeatDays!,
                    ),
                  ],
                ),
              ),
            ),
            itemCount: numberOfRoutines ?? 0,
          ),
          physics: NeverScrollableScrollPhysics(), // 타임라인 빌더 내 스크롤 막기
        ),
      ),
    );
  }
}
