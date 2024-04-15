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
  int _addItemCnt = 0;
  ReportController reportController = ReportController();
  late Future<List<ReportModel>> reports;
  var thisMonth = '${DateTime.now().year}-${DateTime.now().month}';

  // List<List<String>> datedummy = [
  //   ['2024.02.11', '2024.02.17'],
  //   ['2024.02.04', '2024.02.10'],
  //   ['2024.01.28', '2024.02.03'],
  //   ['2024.01.21', '2024.01.27'],
  //   ['2024.01.14', '2024.01.20'],
  //   ['2024.01.07', '2024.01.13'],
  // ];

  @override
  void initState() {
    super.initState();
    reports = reportController.getReport(); // getReport 호출을 initState에서 수행
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: FutureBuilder<List<ReportModel>>(
              future: reports,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // 로딩 중일 때는 로딩 인디케이터 표시
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // 에러 발생 시 에러 메시지 표시
                } else {
                  var reports = snapshot.data!;
                  // 실제 데이터가 준비되었을 때 렌더링하려는 위젯
                  return Container(
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
                              // 아래 container는 reports를 확인하기 위한 코드
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '${reports[0].registeredMemoryCount}',
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ),
                              // for (var report in reports)
                              //   var reportEntry = report.registeredMemoryCount.entries
                              //   if (report.registeredMemoryCount.entries.entry.key.substring(6,7) == thisMonth.substring(5))
                              //     ReportHistoryContainer(date: date)
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
                              // ListView(
                              //   shrinkWrap: true,
                              //   physics: NeverScrollableScrollPhysics(),
                              //   children: List.generate(datedummy.length,
                              //     (index) {
                              //       if (datedummy[index][0].substring(6,7) != thisMonth.substring(5)) {
                              //         return ReportHistoryContainer(date: datedummy[index]);
                              //       } else {
                              //         return Container(); // 아무 것도 보여주지 않는 빈 컨테이너 반환
                              //       }}
                              //   ),
                            // )
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
                              ))
                        ],
                      )
                  );
                }}),
        ));
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
