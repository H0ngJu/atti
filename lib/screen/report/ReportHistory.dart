import 'package:atti/data/auth_controller.dart';
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

  var thisMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
  var lastMonth = '';
  List<List<String>> thisMonthReports = [];
  List<List<String>> lastMonthReports = [];
  List<List<String>> previousReports = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime lastMonthDate = DateTime(now.year, now.month - 1, 1);
    lastMonth = '${lastMonthDate.year}-${lastMonthDate.month.toString().padLeft(2, '0')}';
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    var fetchedReports = await _authController.carerReports;
    for (Map<String, dynamic> report in fetchedReports) {
      List<String> periodList = List<String>.from(report['reportPeriod']);
      String reportMonth = periodList[0].substring(0, 7);
      print(periodList);
      if (reportMonth == thisMonth) {
        thisMonthReports.add(periodList);
      } else if (reportMonth == lastMonth) {
        lastMonthReports.add(periodList);
      } else {
        previousReports.add(periodList);
      }
    }
    setState(() {}); // 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildReportSection(true, '이번 달', thisMonthReports),
                  SizedBox(height: 30),
                  buildReportSection(false, '저번 달', lastMonthReports),
                  SizedBox(height: 30),
                  buildReportSection(false, '이전 기록', previousReports),
                ],
              )),
        ));
  }

  Widget buildReportSection(bool isRecent, String title, List<List<String>> reports) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(bottom: 10),
          child: Text(title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        if (reports.isEmpty)
          Text('데이터가 없습니다.', style: TextStyle(
              fontFamily: 'PretendardRegular', fontSize: 18, color: Colors.grey
          ),),
        for (int i = 0; i < reports.length; i++)
          isRecent
              ? ReportHistoryContainer(date: reports[i], indx: i)
              : PreReportHistoryContainer(
            date: reports[i],
            indx: i + (isRecent ? thisMonthReports.length : 0) + (title == '이전 기록' ? lastMonthReports.length : 0),
          ),
      ],
    );
  }
}


class ReportHistoryContainer extends StatefulWidget {
  final List<String> date;
  final int indx;

  const ReportHistoryContainer(
      {Key? key, required this.date, required this.indx})
      : super(key: key);

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
      int weekOfMonth =
          ((datetime.day + firstWeekdayOfMonth - 1) / 7).floor() + 1;
      return weekOfMonth;
    }

    int weekOfMonth = getWeekOfMonth(datetime);

    return GestureDetector(
        onTap: () {
          Get.to(ReportDetail(indx: widget.indx));
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
                style: TextStyle(
                    color: Color(0xff737373),
                    fontFamily: 'PretendardRegular',
                    fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${date[0].substring(6, 7)}월 ${weekOfMonth}주차 기록 보고',
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ));
  }
}

class PreReportHistoryContainer extends StatefulWidget {
  final List<String> date;
  final int indx;

  const PreReportHistoryContainer(
      {Key? key, required this.date, required this.indx})
      : super(key: key);

  @override
  State<PreReportHistoryContainer> createState() => _PreReportHistoryContainerState();
}

class _PreReportHistoryContainerState extends State<PreReportHistoryContainer> {
  @override
  Widget build(BuildContext context) {
    List<String> date = widget.date;

    String dateString = widget.date[0].replaceAll('.', '-');
    DateTime datetime = DateTime.parse(dateString);
    int getWeekOfMonth(DateTime datetime) {
      DateTime firstDayOfMonth = DateTime(datetime.year, datetime.month, 1);
      int firstWeekdayOfMonth = firstDayOfMonth.weekday % 7; // 일요일을 0으로 변환
      int weekOfMonth =
          ((datetime.day + firstWeekdayOfMonth - 1) / 7).floor() + 1;
      return weekOfMonth;
    }

    int weekOfMonth = getWeekOfMonth(datetime);

    return GestureDetector(
        onTap: () {
          Get.to(ReportDetail(indx: widget.indx));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              //color: Color(0xffFFF5DB),
            border: Border.all(color: Color(0xff737373), width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date[0]} ~ ${date[1]}',
                style: TextStyle(
                    color: Color(0xff737373),
                    fontFamily: 'PretendardRegular',
                    fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${date[0].substring(6, 7)}월 ${weekOfMonth}주차 기록 보고',
                style: TextStyle(color: Color(0xff737373), fontFamily: 'PretendardRegular',fontSize: 24),
              )
            ],
          ),
        ));
  }
}
