// 일정 메인 화면
import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/notification/notification.dart';
import 'package:atti/tmp/screen/schedule/register/ScheduleRegister1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import '../../../commons/ScheduleBox.dart';
import '../../../commons/ScheduleModal.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import '../../../data/schedule/schedule_model.dart';

class ScheduleMain extends StatefulWidget {
  const ScheduleMain({super.key});

  @override
  State<ScheduleMain> createState() => _ScheduleMainState();
}

class _ScheduleMainState extends State<ScheduleMain> {
  final AuthController authController = Get.put(AuthController());

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  List<ScheduleModel> schedulesBySelectedDay = []; // 선택된 날짜의 일정들이 반환되는 리스트
  int? numberOfSchedules; // 선택된 날짜의 일정 개수

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    List<ScheduleModel>? fetchedSchedules = await ScheduleService().getSchedulesByDate(_selectedDay);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text('${authController.userName.value}님의',
                textAlign: TextAlign.left, style: TextStyle(
                  fontSize: 24,
                ),),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text('일정',
                      style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w600
                      ),)
                  ),
                  ToggleButton(),
                ],
              ),
            ),
            SizedBox(height: 30),
            ScheduleCalendar(),
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
                  numberOfSchedules != null && numberOfSchedules! >= 1
                  ? ScheduleTimeline()
                  : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: Text('아직 오늘의 일정이 없네요!', style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w600
                    ),),
                  ),
                  SizedBox(height: 10,),
                  NextButton(next: ScheduleRegister1(), content: '일정 등록하기', isEnabled: true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ToggleButton() {
    return ToggleSwitch(
      initialLabelIndex: _calendarFormat == CalendarFormat.week ? 0 : 1,
      totalSwitches: 2,
      labels: ['주간', '월간'],
      fontSize: 16,
      cornerRadius: 20,
      activeBgColor: [Color(0xffFFC215)],
      inactiveBgColor: Color(0xffFFF5DB),
      inactiveFgColor: Color(0xff737373),
      minWidth: 60,
      minHeight: 35,
      onToggle: (index) {
        setState(() {
          _calendarFormat = index == 0
              ? CalendarFormat.week
              : CalendarFormat.month;
        });
      },
    );
  }

  Widget ScheduleCalendar() {
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
          _focusedDay = focusedDay; // update `_focusedDay` here as well
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
          border: Border.all(color: Color(0xffFFC215), width: 1.5)
        ),
      ),
    );
  }

  Widget ScheduleTimeline() {
    return Container(
      height: numberOfSchedules! <= 2
          ? MediaQuery.of(context).size.height * 0.575
          : (numberOfSchedules! * MediaQuery.of(context).size.height * 0.28),

      width: MediaQuery.of(context).size.width * 0.9,
      child: TimelineTheme(
        data: TimelineThemeData(
            nodePosition: 0,
            indicatorPosition: 0,
            color: Color(0xffFFC215),
            connectorTheme: ConnectorThemeData(
                color: Color(0xff9C9C9C),
                indent: 5,
                thickness: 1.5
            ),
            indicatorTheme: IndicatorThemeData(
              size: 17,
            )
        ),
        child: Timeline.tileBuilder(
          builder: TimelineTileBuilder.connectedFromStyle(
            indicatorStyleBuilder: (context, index) {
              return schedulesBySelectedDay[index].isFinished!
                  ? IndicatorStyle.dot
                  : IndicatorStyle.outlined;
            },
            //connectorStyle: ConnectorStyle.dashedLine,
            connectorStyleBuilder: (context, index) => ConnectorStyle.dashedLine,
            lastConnectorStyle: ConnectorStyle.dashedLine,
            //contentsAligIndicatorStyle.dot,
            contentsBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),

              // 각 타임라인 타일
              child: GestureDetector(
                onTap: () {
                  // 타일 클릭 시 모달창
                  showDialog(context: context, builder: (_) {
                    return ScheduleModal(
                      time: DateFormat('a h시 mm분', 'ko_KR').format(schedulesBySelectedDay[index].time!.toDate()),
                      location: schedulesBySelectedDay[index].location!,
                      name: schedulesBySelectedDay[index].name!,
                      memo: schedulesBySelectedDay[index].memo,
                      docRef: schedulesBySelectedDay[index].reference!,
                    );
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(schedulesBySelectedDay[index].isFinished! ? '완료됨' : '완료되지 않음',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xff737373),
                        fontSize: 18,
                      ), ),
                    SizedBox(height: 10,),
                    ScheduleBox(
                      time: DateFormat('a hh:mm', 'ko_KR').format(schedulesBySelectedDay[index].time!.toDate()),
                      location: schedulesBySelectedDay[index].location,
                      name: schedulesBySelectedDay[index].name,
                    ),
                  ],
                ),
              ),
            ),
            itemCount: numberOfSchedules ?? 0,
          ),
          physics: NeverScrollableScrollPhysics(), // 타임라인 빌더 내 스크롤 막기
        ),
      ),
    );
  }



}
