import 'package:atti/index.dart';


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

    final ColorPallet colorPallet = Get.put(ColorPallet());

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
    String percentString = "${percent.toStringAsFixed(0)}%";
    String countText = "$completedRoutines/$totalRoutines";

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                const SizedBox(),
                // 상단 닫기 버튼
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xffB8B8B8),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            SizedBox(height: 5, width: width * 0.8,),
            // 제목
            Container(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 30),
                )),
            SizedBox(height: height * 0.01,),
            const Text(
              '이번달 일과 완료율',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  percentString,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 30,),
                Text(
                  countText,
                  style: const TextStyle(fontSize: 22),
                )
              ],
            ),
            const SizedBox(height: 20 ),
            // 캘린더 그리드 (가로 7개씩)
            Expanded(
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                      // 셀에 표시할 내용(원 내부)을 결정
                      Widget content;

                      if (cellDate.isAfter(DateTime.now())) {
                        // 오늘 이후의 날짜: 아이콘이나 채우기 없이 점선 원만 표시
                        content = CustomPaint(
                          painter: RoutineDottedCirclePainter(),
                          child: const SizedBox(
                            width: 30,
                            height: 30,
                          ),
                        );
                      } else if (!isFinished.containsKey(cellDate.toString())) {
                        // 해당 날짜에 루틴 데이터가 없으면: 회색으로 채운 원 위에 점선 테두리
                        content = Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: colorPallet.lightGrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            CustomPaint(
                              painter: RoutineDottedCirclePainter(),
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        );
                      } else if (isFinished[cellDate.toString()] == true) {
                        // 루틴이 완료된 날: check 아이콘 표시
                        content = CustomPaint(
                          painter: RoutineDottedCirclePainter(),
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        );
                      } else {
                        // 루틴이 있지만 완료되지 않은 날: x 아이콘 표시 (컬러팔레트 사용)
                        content = CustomPaint(
                          painter: RoutineDottedCirclePainter(),
                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: colorPallet.orange,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          content,
                          const SizedBox(height: 3,),
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
