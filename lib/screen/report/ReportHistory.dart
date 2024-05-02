import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/report/reportController.dart';
import 'package:atti/screen/report/ReportDetail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReportHistory extends StatefulWidget {
  const ReportHistory({Key? key}) : super(key: key);


  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  final AuthController _authController = Get.find<AuthController>();
  int _addItemCnt = 0;
  var thisMonth = '${DateTime.now().year}-${DateTime.now().month}';
  List<String> reportPeriods = [];

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    var fetchedReports = await _authController.carerReports;
    if (fetchedReports.isNotEmpty) {
      reportPeriods = fetchedReports.map<String>((snapshot) {
        var reportPeriod = snapshot.data()['reportPeriod'];
        return List<String>.from(reportPeriod);
      }).toList(); // 결과를 리스트로 변환
    }
    setState(() {
      reportPeriods = reportPeriods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          '이번 달',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text('이전 받은 기록 보고',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold))),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _addItemCnt += 2; // 버튼을 누를 때마다 추가 아이템 개수 업데이트
                          });
                        },
                        child: Text(
                          '이전 기록 보고 더보기',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFC215),
                            padding: EdgeInsets.symmetric(vertical: 10)),
                      )
                  ),
                  ReportHistoryContainer(
                    date: [],
                  ),
                ],
              )
          ),
        )
    );
  }
}

class ReportHistoryContainer extends StatefulWidget {
  final List<String> date;

  const ReportHistoryContainer({Key? key, required this.date}) : super(key: key);

  @override
  State<ReportHistoryContainer> createState() => _ReportHistoryContainerState();
}

class _ReportHistoryContainerState extends State<ReportHistoryContainer> {
  @override
  Widget build(BuildContext context) {
    List<String> date = widget.date;

    String dateString = widget.date[0].replaceAll('.', '-');
    DateTime datetime = DateTime.parse(dateString);
    int getWeekOfMonth(DateTime datetime) {
      DateTime firstDayOfMonth = DateTime(datetime.year, datetime.month, 1);
      int firstWeekdayOfMonth = firstDayOfMonth.weekday % 7; // 일요일을 0으로 변환
      int weekOfMonth = ((datetime.day + firstWeekdayOfMonth - 1) / 7).floor() + 1;
      return weekOfMonth;
    }

    int weekOfMonth = getWeekOfMonth(datetime);

    return GestureDetector(
        onTap: () {
          Get.to(ReportDetail());
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Color(0xffFFF5DB),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date[0]} ~ ${date[1]}',
                style: TextStyle(color: Color(0xffA38130), fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${date[0].substring(6,7)}월 ${weekOfMonth}주차 기록 보고',
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        )
    );
  }
}
