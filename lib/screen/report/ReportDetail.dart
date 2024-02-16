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
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      '이번 주 기록 보고',
                      style: TextStyle(fontSize: 30),
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
      children: [Text('미완료 알림')],
    );
  }
}

class MemoryInfo extends StatelessWidget {
  const MemoryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int MemoryNum = 5;
    final graphColor = Color(0xffFFC215);
    return Column(
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
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 2,
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false, )),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))
              ),
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
    );
  }
}

class EmotionInfo extends StatelessWidget {
  const EmotionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MostViewMemory extends StatelessWidget {
  const MostViewMemory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
