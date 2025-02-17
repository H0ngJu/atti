import 'package:atti/data/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ReportHistory.dart';

class ReportDetail extends StatefulWidget {
  final int indx;

  const ReportDetail({Key? key, required this.indx}) : super(key: key);

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  final AuthController _authController = Get.find<AuthController>();
  var reportData = {};
  List<dynamic>? reportPeriod;
  Map<String, dynamic>? weeklyEmotion;
  String? highestViewedMemory;
  DocumentReference? patientId;
  var routineCompletion;
  var unfinishedRoutine;
  var scheduleCompletion;
  var unfinishedSchedule;
  var mostViews;
  var registerdMemoryCount;
  var dangerWords;

  int totalRoutines = 0;
  int completedRoutines = 0;
  int totalSchedules = 0;
  int completedSchedules = 0;

  Map<String, dynamic>? highestViewedData;
  @override
  void initState() {
    super.initState();
    _fetchReport();
  }
  Future<void> fetchHighestViewedDocument() async {
    // mostViews 맵에서 가장 높은 조회수를 가진 참조 찾기
    String? highestViewedReference;
    int highestViews = 0;
    mostViews.forEach((reference, views) {
      if (views > highestViews) {
        highestViews = views;
        highestViewedReference = reference;
      }
    });

    if (highestViewedReference != null) {
      // Firestore에서 해당 참조를 사용하여 도큐먼트 가져오기
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.doc(highestViewedReference!).get();
        setState(() {
          highestViewedData = documentSnapshot.data() as Map<String, dynamic>?;
          highestViewedData!['viewCounts'] = highestViews;
        });
        print("highestViewedData : ${highestViewedData!['refernece']}");
      } catch (e) {
        print("도큐먼트를 가져오는 데 실패했습니다: $e");
      }
    }
  }

  Future<void> _fetchReport() async {
    var fetchedReports = await _authController.carerReports;
    reportData = fetchedReports[widget.indx];
    setState(() {
      reportPeriod = reportData['reportPeriod'];
      weeklyEmotion = reportData['weeklyEmotion'];
      dangerWords = reportData['dangerWords'];
      highestViewedMemory = reportData['highestViewedMemory'];
      patientId = reportData['patientId'];
      routineCompletion = reportData['routineCompletion'];
      unfinishedRoutine = reportData['unfinishedRoutine'];
      scheduleCompletion = reportData['scheduleCompletion'];
      unfinishedSchedule = reportData['unfinishedSchedule'];
      mostViews = reportData['mostViews'];
      registerdMemoryCount = reportData['registerdMemoryCount'];
      routineCompletion.forEach((date, data) {
        int total = (data['total'] as num?)?.toInt() ?? 0; // num을 int로 변환, 기본값 0
        int completed = (data['completed'] as num?)?.toInt() ?? 0; // 위와 동일

        totalRoutines += total;
        completedRoutines += completed;
      });
      scheduleCompletion.forEach((date, data) {
        int total = (data['total'] as num?)?.toInt() ??
            0; // num을 int로 변환, 기본값 0
        int completed = (data['completed'] as num?)?.toInt() ?? 0; // 위와 동일

        totalSchedules += total;
        completedSchedules += completed;
      });
    });
    DateTime date = DateTime.parse("2024-05-03");
    Timestamp timestampKey = Timestamp.fromDate(date);
    Map<String, int>? entry = routineCompletion[timestampKey];
    print(entry);
    fetchHighestViewedDocument();
    print("$scheduleCompletion\n$routineCompletion");
  }

  Widget TileContainer({int total = 0, int completed = 0, required String date}) {
    double completionPercentage = total != 0 ? (completed / total) * 100 : 0;
    Color tileColor = _calculateTileColor(completionPercentage);

    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xffDDDDDD), width: 1)
      ),
      padding: const EdgeInsets.all(13),
      child:
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          '${date.substring(8, 10)}일',
          style: const TextStyle(fontFamily: 'PretendardRegular', fontSize: 20),
        ),
        Text(
          '$completed/$total',
          style: const TextStyle(
              fontFamily: 'PretendardRegular',
              fontSize: 24,
              color: Color(0xffA38130)),
        ),
      ]),
    );
  }

  // 완료율에 따른 색상을 계산
  Color _calculateTileColor(double completionPercentage) {
    if (completionPercentage == 100) {
      return const Color(0xFFFFD356); // 완료율이 100%일 때의 색상
    } else if (completionPercentage == 0) {
      return Colors.white; // 완료율이 0%일 때의 색상
    } else {
      // 완료율이 0%와 100% 사이에 있는 경우 투명도 조절
      double opacity = completionPercentage / 100;
      return Color.fromRGBO(255, 211, 86, opacity);
    }
  }

  Widget RoutineSummary() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    List<MapEntry<String, dynamic>> sortedEntries = routineCompletion.entries.toList()
      ..sort((MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) => a.key.compareTo(b.key));
    List<Widget> tiles = sortedEntries.map((entry) {
      return TileContainer(
        date: entry.key,
        total: entry.value['total'],
        completed: entry.value['completed'],
      );
    }).toList();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일정 및 일과',
            style: TextStyle(fontSize: 28, fontFamily: 'PretendardMedium'),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '일과 완료율',
                style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              ),
              Text(
                totalRoutines != 0 ?
                '${(completedRoutines / totalRoutines * 100).toStringAsFixed(1)} %':
                "지난 주 일정이 없어요",
                style: const TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              )
            ],
          ),
          SizedBox(
            // color: Colors.red,
            // 영역 확인용
            height: MediaQuery.of(context).size.height * 0.45,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              children: tiles,
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
    List<MapEntry<String, dynamic>> sortedEntries = scheduleCompletion.entries.toList()
      ..sort((MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) => a.key.compareTo(b.key));
    List<Widget> tiles = sortedEntries.map((entry) {
      return TileContainer(
        date: entry.key,
        total: entry.value['total'],
        completed: entry.value['completed'],
      );
    }).toList();

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '일정 완료율',
                style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              ),
              Text(
                totalSchedules != 0 ?
                '${(completedSchedules / totalSchedules * 100).toStringAsFixed(1)} %':
                "지난 주 일정이 없어요",
                style: const TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              )
            ],
          ),
          SizedBox(
            // color: Colors.red,
            // 영역 확인용
            height: MediaQuery.of(context).size.height * 0.45,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              children: tiles,
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
          const Text(
            '내 기억',
            style: TextStyle(fontSize: 28, fontFamily: 'PretendardMedium'),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            '회상 대화 주요 감정',
            style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
          ),
          if (weeklyEmotion!.isNotEmpty)
            Wrap(
              spacing: 8.0, // 가로 방향 자식 사이의 간격
              runSpacing: 4.0, // 세로 방향 자식 사이의 간격
              children: weeklyEmotion!.keys.map((emotion) => TagContainer(emotion)).toList(),
            ),
        ],
      ),
    );
  }

  Widget TagContainer(String tag) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xffDDDDDD), width: 1)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 24, color: Color(0xffA38130)),
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
          const Text(
            '위험 단어 분석',
            style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
          ),
          const SizedBox(
            height: 10,
          ),
          if (dangerWords!.length > 0)
            ...dangerWords!.keys.map((emotion) => TagContainer(emotion)).toList(),
          if (dangerWords!.length == 0)
            const Text("위험 단어가 없어요",
              style:
              TextStyle(fontSize: 24, color: Color(0xffA38130)
              ,fontFamily: 'PretendardRegular'),
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
          const Text('최다 열람 기억', style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular',)),
          const SizedBox(height: 10,),
          highestViewedData != null ? Row( // 여기서 삼항 연산자를 사용합니다.
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  highestViewedData!['img'],
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
                      Text('${highestViewedData!['era']}년대',
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'PretendardRegular',
                              color: Color(0xffA38130))),
                      Text('${highestViewedData!['imgTitle']}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'PretendardRegular',
                              color: Color(0xffA38130))),
                      Text('${highestViewedData!['viewCounts']}회 열람',
                          style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'PretendardRegular',
                              color: Color(0xffA38130)))
                    ],
                  )
              )
            ],
          ) : const Center(child: Text('데이터를 불러오는 중...')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime reportStartDate = DateTime.parse(reportPeriod![0]);
    DateTime reportEndDate = DateTime.parse(reportPeriod![1]);
    final weekOfMonth = getWeekOfMonth(reportStartDate);

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 50),
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
                          '${reportStartDate.month}월 $weekOfMonth주차 기록 보고',
                          style: const TextStyle(
                              fontSize: 28, fontFamily: 'PretendardMedium'),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(const ReportHistory());
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffFFC215),
                            minimumSize: const Size(100, 30)),
                        child: const Text(
                          '지난 기록',
                          style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
                        ))
                  ],
                ),
                const SizedBox(height: 10,),
                Text(
                  '${reportStartDate.year}년 ${reportStartDate.month}월 ${reportStartDate.day}일 - ${reportEndDate.year}년 ${reportEndDate.month}월 ${reportEndDate.day}일',
                  style: const TextStyle(
                      fontFamily: 'PretendardRegular',
                      fontSize: 20,
                      color: Color(0xff737373)),
                ),
                const SizedBox(
                  height: 20,
                ),
                RoutineSummary(),
                const Divider(height: 40),
                ScheduleSummary(),
                const Divider(height: 40),
                Emotion(),
                const Divider(height: 40),
                DangerousWord(),
                const Divider(height: 40),
                MostReadMem(),
                const SizedBox(height: 40,)
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
class TagContainer extends StatelessWidget {
  final String tag;
  const TagContainer({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xffDDDDDD), width: 1)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 24, color: Color(0xffA38130)),
      ),
    );
  }
}
