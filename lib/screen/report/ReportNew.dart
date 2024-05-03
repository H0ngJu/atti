import 'package:atti/data/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ReportHistory.dart';

class ReportNew extends StatefulWidget {
  final int indx;

  const ReportNew({Key? key, required this.indx}) : super(key: key);

  @override
  State<ReportNew> createState() => _ReportNewState();
}

class _ReportNewState extends State<ReportNew> {
  //DateTime _selectedDay = DateTime.now();

  // ==================================================================================================================================
  AuthController _authController = Get.find<AuthController>();
  var reportData = {};
  List<String>? reportPeriod;
  Map<String, int>? weeklyEmotion;
  String? highestViewedMemory;
  DocumentReference? patientId;
  var routineCompletion;
  var unfinishedRoutine;
  var scheduleCompletion;
  var unfinishedSchedule;
  var mostViews;
  var registerdMemoryCount;



  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    var fetchedReports = await _authController.carerReports;
    reportData = fetchedReports[widget.indx];
    print("reportData : ${reportData}");
    setState(() {
      reportPeriod = reportData['reportPeriod'];
      weeklyEmotion = reportData['weeklyEmotion'];
      highestViewedMemory = reportData['highestViewedMemory'];
      patientId = reportData['patientId'];
      routineCompletion = reportData['routineCompletion'];
      unfinishedRoutine = reportData['unfinishedRoutine'];
      scheduleCompletion = reportData['scheduleCompletion'];
      unfinishedSchedule = reportData['unfinishedSchedule'];
      mostViews = reportData['mostViews'];
      registerdMemoryCount = reportData['registerdMemoryCount'];
    });
  }
  // ==================================================================================================================================

  Widget TileContainer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: BoxDecoration(
          color: Color(0xffFFE29A), borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.all(13),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '7일',
          style: TextStyle(fontFamily: 'PretendardRegular', fontSize: 24),
        ),
        Text(
          '4/5',
          style: TextStyle(
              fontFamily: 'PretendardRegular',
              fontSize: 24,
              color: Color(0xffA38130)),
        ),
      ]),
    );
  }

  Widget RoutineSummary() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '일정 및 일과',
            style: TextStyle(fontSize: 28, fontFamily: 'PretendardMedium'),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '일과 완료율',
                style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              ),
              Text(
                '70%',
                style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              )
            ],
          ),
          Container(
            // color: Colors.red,
            // 영역 확인용
            height: MediaQuery.of(context).size.height * 0.45,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              children: List.generate(7, (index) {
                return TileContainer();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget ScheduleSummary() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '일정 완료율',
                style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              ),
              Text(
                '70%',
                style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              )
            ],
          ),
          Container(
            // color: Colors.red,
            // 영역 확인용
            height: MediaQuery.of(context).size.height * 0.45,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              children: List.generate(7, (index) {
                return TileContainer();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget Emotion() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 기억',
            style: TextStyle(fontSize: 28, fontFamily: 'PretendardMedium'),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '회상 대화 주요 감정',
            style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
          ),
          TagContainer()
        ],
      ),
    );
  }

  Widget TagContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Color(0xffDDDDDD), width: 1)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        '행복한',
        style: TextStyle(fontSize: 24, color: Color(0xffA38130)),
      ),
    );
  }

  Widget DangerousWord() {
    bool isExist = false;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '위험 단어 분석',
            style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
          ),
          SizedBox(
            height: 10,
          ),
          isExist
              ? TagContainer()
              : Text(
                  '대화에서 발견된 위험 단어가 없습니다.',
                  style: TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 22,
                      color: Color(0xfffA38130)),
                )
        ],
      ),
    );
  }

  Widget MostReadMem() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('최다 열람 기억', style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular',)),
          SizedBox(height: 10,),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202303/21/73fb5504-fa6c-4fa9-b3d4-160b8a455556.jpg',
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('2020년대',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'PretendardRegular',
                          color: Color(0xffA38130))),
                  Text('벚꽃 축제',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'PretendardRegular',
                          color: Color(0xffA38130))),
                  Text('3회 열람',
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'PretendardRegular',
                          color: Color(0xffA38130)))
                ],
              ))
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final weekOfMonth = getWeekOfMonth(now);
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));



    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${now.month}월 ${weekOfMonth}주차 기록 보고',
                      style: TextStyle(
                          fontSize: 28, fontFamily: 'PretendardMedium'),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Get.to(ReportHistory());
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xffFFC215),
                        minimumSize: Size(100, 30)),
                    child: Text(
                      '지난 기록',
                      style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
                    ))
              ],
            ),
            Text(
              '${now.year}년 ${now.month}월 ${now.day}일 - ${now.year}년 ${now.month}월 ${now.day}일',
              style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 20,
                  color: Color(0xff737373)),
            ),
            SizedBox(
              height: 20,
            ),
            RoutineSummary(),
            Divider(height: 40),
            ScheduleSummary(),
            Divider(height: 40),
            Emotion(),
            Divider(height: 40),
            DangerousWord(),
            Divider(height: 40),
            MostReadMem(),
            SizedBox(height: 40,)
          ],
        ),
      ),
    ));
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
