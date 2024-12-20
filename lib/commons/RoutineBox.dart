import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../data/routine/routine_controller.dart';
import 'colorPallet.dart';


class RoutineBox extends StatefulWidget {
  const RoutineBox({super.key, required this.time, required this.name, required this.img, required this.days});
  final time;
  final name;
  final img;
  final days;

  @override
  State<RoutineBox> createState() => _RoutineBoxState();
}

class _RoutineBoxState extends State<RoutineBox> {
  final RoutineController routineController = Get.put(RoutineController());
  final ColorPallet colorPallet = Get.put(ColorPallet());

  String generateRepeatText(List<String> days) {
    if (days.length == 7) {
      return '매일 반복';
    } else {
      String repeatText = '';
      for (int i = 0; i < days.length; i++) {
        if (i == days.length - 1) {
          repeatText += days[i];
        } else {
          repeatText += days[i] + ', ';
        }
      }
      return '$repeatText 반복';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // 시간 변환
    String formattedTime = '';
    if (widget.time != null && widget.time.length == 2) {
      final int hour = widget.time[0];
      final int minute = widget.time[1];
      final bool isPM = hour >= 12; // 오후 여부 확인
      int hour12 = hour > 12 ? hour - 12 : hour;
      hour12 = hour12 == 0 ? 12 : hour12;
      formattedTime = '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 24,
              height: 1.2
          ),),
          Text(
            widget.name,
            style: TextStyle(
                fontSize: 28,
                height: 1.2
            ),
          ),
          SizedBox(height: 10,),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.img != null && widget.img.contains('http')
                    ? Image.network(
                  widget.img,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
                    : (widget.img != null && File(widget.img!).existsSync())
                      ? Image.file(
                        File(routineController.routine.value.img!),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )
                      : Container(),
              ),
            ),

          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                generateRepeatText(widget.days),
                style: TextStyle(
                    fontSize: 22,
                    color: colorPallet.grey
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

