import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportDetail extends StatelessWidget {
  const ReportDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      '1월 3주차',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '이번 주 기록 보고',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                    width: 135,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFC215)),
                        child: Text(
                          '지난 기록',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RoutineInfo(),
            Divider(),
            MemoryInfo(),
            Divider(),
            EmotionInfo(),
            Divider(),
            MostViewMemory()
          ],
        ),
      ),
    ));
  }
}

class RoutineInfo extends StatelessWidget {
  const RoutineInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '미완료 일과',
          style: TextStyle(fontSize: 24),
        ),
        Text(
          'n개의 일과를 완료하지 못했어요.',
          style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
        ),
      ],
    );
  }
}

class MemoryInfo extends StatelessWidget {
  const MemoryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int MemoryNum = 5;
    final graphColor = Color(0xffFFC215);
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기억 등록 추이',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '이번주에 총 $MemoryNum개의 기억을 등록했어요',
              style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
            ),
            Container(
                height: 200,
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 2,
                  titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: false,
                      )),
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false))),
                  barGroups: [
                    BarChartGroupData(
                      x: 15,
                      barRods: [
                        BarChartRodData(fromY: 0, color: graphColor, toY: 1)
                      ],
                    ),
                    BarChartGroupData(
                      x: 16,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 0, color: graphColor)
                      ],
                    ),
                    BarChartGroupData(
                      x: 17,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 2, color: graphColor)
                      ],
                    ),
                    BarChartGroupData(
                      x: 18,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 0, color: graphColor)
                      ],
                    ),
                    BarChartGroupData(
                      x: 19,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 0, color: graphColor)
                      ],
                    ),
                    BarChartGroupData(
                      x: 20,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 2, color: graphColor)
                      ],
                    ),
                    BarChartGroupData(
                      x: 21,
                      barRods: [
                        BarChartRodData(fromY: 0, toY: 0, color: graphColor)
                      ],
                    ),
                  ],
                )))
          ],
        ));
  }
}

class EmotionInfo extends StatelessWidget {
  const EmotionInfo({Key? key}) : super(key: key);

  Widget EmotionTag(emotion) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color(0xffFFF5DB), borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        '${emotion}',
        style: TextStyle(color: Color(0xffA38130), fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> emotionList = ['행복함', '즐거움', '편안함', '기타'];

    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '기억 회상 감정기록',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '최근 7일간 아띠와의 회상 대화에서 이러한 감정을 느끼고 있어요.',
              style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
            ),
            Wrap(
              children: emotionList.map((emotion) {
                return EmotionTag(emotion);
              }).toList(),
            )
          ],
        ));
  }
}

class MostViewMemory extends StatelessWidget {
  const MostViewMemory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mostViewMemTime = '2020년대';
    String mostViewMemTitle = '제주도 여행';
    int mostViewMemNum = 3;
    String mostViewMemImg =
        'https://img.freepik.com/premium-photo/air-plane-flying-in-a-beatiful-blue-sky-view-out-airplane-view-of-the-wing-of-the-plane-and-the-city-and-the-road-in-the-morning-at-dawnxa_131573-225.jpg';
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '기억 회상 감정기록',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '최근 7일간 아띠와의 회상 대화에서 이러한 감정을 느끼고 있어요.',
              style: TextStyle(fontSize: 20, color: Color(0xffA38130)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFFF5DB),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${mostViewMemTime}',
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            '${mostViewMemTitle}',
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      ),
                      Text(
                        '${mostViewMemNum}회 열람',
                        style:
                            TextStyle(fontSize: 24, color: Color(0xffA38130)),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            mostViewMemImg,
                            fit: BoxFit.fill,
                          )))
                ],
              ),
            )
          ],
        ));
  }
}