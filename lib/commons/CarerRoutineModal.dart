import 'package:atti/commons/BottomNextButton.dart';
import 'package:flutter/material.dart';

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

    // 이번 달의 날짜 수를 구함
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,

      content: SizedBox(
        height: height * 0.7,
        width: width * 0.85,
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
            SizedBox(
              width: width * 0.7,
              child: Row(
                children: [
                  Text(
                    '90%',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    '완료 개수/오늘 날짜',
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
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
                              child: Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.black,
                              ),
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
