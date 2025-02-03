import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import 'colorPallet.dart';

class CarerRoutineModal extends StatelessWidget {
  const CarerRoutineModal({
    super.key,
    required this.name,
    required this.isFinished
  });

  final String name;
  final Map<String, bool> isFinished;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final ColorPallet _colorPallet = Get.put(ColorPallet());

    // 이번 달의 날짜 수를 구함
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // 이번 달의 오늘 날짜까지의 루틴 개수와 완료된 루틴 개수를 계산
    int totalRoutines = 0;
    int completedRoutines = 0;
    isFinished.forEach((key, value) {
      // key를 DateTime으로 파싱 (예: "2025-02-01 00:00:00.000")
      DateTime entryDate = DateTime.parse(key);
      if (entryDate.year == now.year &&
          entryDate.month == now.month &&
          entryDate.day <= now.day) {
        totalRoutines++;
        if (value == true) {
          completedRoutines++;
        }
      }
    });
    double percent = totalRoutines > 0 ? (completedRoutines / totalRoutines * 100) : 0;
    String percentString = percent.toStringAsFixed(0) + "%";
    String countText = "$completedRoutines/$totalRoutines";

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,

      content: SizedBox(
        height: height * 0.7,
        width: width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                // 상단 닫기 버튼
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Color(0xffB8B8B8),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            SizedBox(height: 5, width: width * 0.8,),
            // 제목
            Container(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(height: height * 0.01,),
            Text(
              '이번달 일과 완료율',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  percentString,
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(width: 30,),
                Text(
                  countText,
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
            SizedBox(height: 20 ),
            // 캘린더 그리드 (가로 7개씩)
            Expanded(
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.7
                    ),
                    itemCount: daysInMonth,
                    itemBuilder: (context, index) {
                      int day = index + 1;

                      // 각 셀의 날짜 (시간은 00:00:00.000)
                      final DateTime cellDate = DateTime(now.year, now.month, day);
                      Widget iconWidget;

                      // 오늘 이후의 날짜는 표시하지 않음
                      if (cellDate.isAfter(DateTime.now())) {
                        iconWidget = Container();
                      }

                      // isFinished 맵에 해당 날짜의 키가 없으면, 해당 날은 루틴이 없는 날이므로 "-" 표시
                      else if (!isFinished.containsKey(cellDate.toString())) {
                        iconWidget = const Text(
                          "-",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        );
                      }

                      // 루틴 완료한 날 → check 아이콘
                      else if (isFinished[cellDate.toString()] == true) {
                        iconWidget = const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.black,
                        );
                      }

                      // 루틴이 있지만 완료되지 않은 날 → x 아이콘
                      else {
                        iconWidget = Icon(
                          Icons.close,
                          size: 20,
                          color: _colorPallet.orange
                        );
                      }

                      return Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          // 점선 외곽 원
                          CustomPaint(
                            painter: RoutineDottedCirclePainter(),
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              child: iconWidget
                            ),
                          ),
                          SizedBox(height: 3,),
                          Text(
                            '$day',
                            style: TextStyle(
                                fontSize: 15, color: colorPallet.grey),
                          )
                        ],
                      );
                    }))

          ],
        ),
      ),
    );
  }
}


// 점선 외곽선 Painter
class RoutineDottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    double dashWidth = 4; // 점선의 길이
    double dashSpace = 2; // 점선 사이의 간격

    var circumference = 2 * 3.14159265359 * radius; // 원의 둘레
    int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    double anglePerDash = (3.14159265359 * 2) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      double startAngle = i * anglePerDash;
      double endAngle = startAngle + dashWidth / radius;

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
