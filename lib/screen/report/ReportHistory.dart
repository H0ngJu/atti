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
                      ReportHistoryContainer()
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
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(5 + _addItemCnt,
                            (index) => ReportHistoryContainer()),
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
              )),
        ));
  }
}

class ReportHistoryContainer extends StatefulWidget {
  const ReportHistoryContainer({Key? key}) : super(key: key);

  @override
  State<ReportHistoryContainer> createState() => _ReportHistoryContainerState();
}

class _ReportHistoryContainerState extends State<ReportHistoryContainer> {
  @override
  Widget build(BuildContext context) {
    List<String> date = ['2023.12.25', '2023.12.31'];
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
                '1월 1주차 기록 보고',
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ));
  }
}
