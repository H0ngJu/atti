import 'package:atti/data/auth_controller.dart';
import 'package:atti/screen/report/_ReportDetail.dart';
import 'package:atti/screen/report/ReportNew.dart';
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
  var thisMonth = '${DateTime
      .now()
      .year}-${DateTime
      .now()
      .month}';
  List<List<String>> reportPeriods = [];
  int monthIdx = 0; // 이번 달과 일치하는 month의 인덱스를 세기 위한 변수

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    var fetchedReports = await _authController.carerReports;
    String thisMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
    for (Map<String, dynamic> report in fetchedReports) {
      List<String> periodList = List<String>.from(report['reportPeriod']);
      reportPeriods.add(periodList);
      if (periodList.isNotEmpty && periodList[0].startsWith(thisMonth)) {
        monthIdx++;
      }
    }
  }

  void updateAddItemCnt() {
    var reportPeriodsCount = reportPeriods.length; // reportPeriods 배열의 원소 개수
    if (_addItemCnt + monthIdx + 2 <= reportPeriodsCount) {
      _addItemCnt += 2; // _addItemCnt를 2 증가
    } else if (_addItemCnt + monthIdx < reportPeriodsCount) {
      _addItemCnt = reportPeriodsCount - monthIdx; // _addItemCnt를 조정하여 최대치에 도달하도록 함
    }
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
                      for (int i = 0; i < monthIdx; i++)
                        ReportHistoryContainer(
                          date: reportPeriods[i],
                          indx: i,
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
                                  fontSize: 24, fontWeight: FontWeight.bold)
                          )
                      ),
                      for (int i = 0; i < _addItemCnt; i++)
                        ReportHistoryContainer(
                          date: reportPeriods[monthIdx + i],
                          indx: i,
                        ),
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
                            updateAddItemCnt();
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
                ],
              )
          ),
        )
    );
  }
}

class ReportHistoryContainer extends StatefulWidget {
  final List<String> date;
  final int indx;

  const ReportHistoryContainer({Key? key, required this.date, required this.indx}) : super(key: key);

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
          Get.to(ReportNew(indx: widget.indx));
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
