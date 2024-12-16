// 일정 박스 UI (시간, 이름, 장소)
// 사용법 :
// ScheduleBox(
//                   time: scheduleController.time.value,
//                   name: scheduleController.name.value,
//                   location: scheduleController.location.value,
//                 ),
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../patient/screen/routine_schedule/ScheduleFinishModal.dart';

class ScheduleBox extends StatefulWidget {
  const ScheduleBox(
      {super.key,
        this.time,
        this.name,
        this.location,
        required this.isFinished,
        this.docRef});

  final String? time;
  final String? name;
  final String? location;
  final bool isFinished;
  final DocumentReference? docRef;

  @override
  State<ScheduleBox> createState() => _ScheduleBoxState();
}

class _ScheduleBoxState extends State<ScheduleBox> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            // 완료용 토글 버튼
            GestureDetector(
              onTap: () {
                if (!widget.isFinished) { // 완료여부 false일때만 동작
                  showDialog(
                      context: context,
                      builder: (_) {
                        return ScheduleFinishModal(
                          time: widget.time ?? '',
                          location: widget.location ?? '',
                          name: widget.name!,
                          docRef: widget.docRef!,
                        );
                      });
                }
              },
              child: CustomPaint(
                painter: DottedCirclePainter(),
                child: Container(
                  width: width * 0.12,
                  height: width * 0.12,
                  alignment: Alignment.center,
                  child: widget.isFinished
                  ? const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 30,
                  )
                    : null,
                ),
              ),
            ),
            SizedBox(width: width * 0.06,),

            // 일정 시간
            Text(
              widget.time ?? '-',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            SizedBox(width: width * 0.08,),

            // 일정 제목
            Expanded( // Row 내부에서 텍스트를 유연하게 줄이기 위해 Expanded 사용
              child: Text(
                widget.name ?? '',
                style: TextStyle(
                  fontSize: 28,
                ),
                overflow: TextOverflow.ellipsis, // overflow 발생 시 ... 표시
                maxLines: 1, // 한 줄로 제한
                softWrap: false, // 텍스트 줄바꿈 비활성화
              ),
            ),
          ],
        ));
  }
}

// 점선 외곽선 Painter
class DottedCirclePainter extends CustomPainter {
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
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
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