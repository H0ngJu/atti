import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../data/routine/routine_controller.dart';
import '../patient/screen/routine_schedule/RoutineFinishModal.dart';

class RoutineBox2 extends StatefulWidget {
  final Function onCompleted; // 콜백 함수 추가

  const RoutineBox2(
      {super.key,
      required this.time,
      required this.img,
      required this.name,
      required this.docRef,
      required this.date,
      required this.isFinished,
      required this.onCompleted,
      required this.isEditMode});

  final time;
  final name;
  final img;
  final isFinished;
  final date;
  final DocumentReference docRef;
  final bool isEditMode;

  @override
  State<RoutineBox2> createState() => _RoutineBox2State();
}

class _RoutineBox2State extends State<RoutineBox2> {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
    // 시간 변환
    String formattedTime = '';
    if (widget.time != null && widget.time.length == 2) {
      final int hour = widget.time[0];
      final int minute = widget.time[1];
      final bool isPM = hour >= 12; // 오후 여부 확인
      int hour12 = hour > 12 ? hour - 12 : hour;
      hour12 = hour12 == 0 ? 12 : hour12;
      formattedTime =
          '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 완료용 토글 버튼
          widget.isEditMode
              ? GestureDetector( // 편집모드일 때 -> 삭제 버튼
                  onTap: () {

                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: colorPallet.orange, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                )
              : GestureDetector( // 편집모드X -> 완료 버튼
                  onTap: () {
                    if (!widget.isFinished) {
                      // 완료여부 false일때만 동작
                      showDialog(
                          context: context,
                          builder: (_) {
                            return RoutineFinishModal(
                              time: widget.time ?? '',
                              name: widget.name!,
                              docRef: widget.docRef!,
                              date: widget.date,
                              onCompleted: widget.onCompleted,
                            );
                          });
                    }
                  },
                  child: CustomPaint(
                    painter: RoutineDottedCirclePainter(),
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 일과 시간
              Container(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                decoration: BoxDecoration(
                  color: widget.isEditMode
                      ? colorPallet.lightGrey
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color:
                        widget.isEditMode ? Colors.transparent : Colors.black,
                    width: 1,
                  ),
                ),
                child: Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),

              // 일과 제목
              Container(
                  width: width * 0.73,
                  padding: widget.isEditMode
                      ? EdgeInsets.fromLTRB(10, 2, 10, 2)
                      : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: widget.isEditMode
                        ? colorPallet.lightGrey
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),

              // 일과 사진
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.73,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.img,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
