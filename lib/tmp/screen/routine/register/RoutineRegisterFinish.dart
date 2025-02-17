import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import '../../../../patient/screen/routine_schedule/RoutineScheduleMain.dart';
import 'dart:io';

class RoutineRegisterFinish extends StatefulWidget {
  const RoutineRegisterFinish({
    super.key,
    required this.time,
    required this.name,
    required this.img
  });
  final time;
  final name;
  final img;

  @override
  State<RoutineRegisterFinish> createState() => _RoutineRegisterFinishState();
}

class _RoutineRegisterFinishState extends State<RoutineRegisterFinish> {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
    String formattedTime = '';
    if (widget.time != null && widget.time.length == 2) {
      final int hour = widget.time[0];
      final int minute = widget.time[1];
      final bool isPM = hour >= 12; // 오후 여부 확인
      int hour12 = hour > 12 ? hour - 12 : hour;
      hour12 = hour12 == 0 ? 12 : hour12;
      formattedTime = '${isPM ? '오후' : '오전'} ${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(left: 15),
                  child: Text('\'${widget.name}\'\n일과를 등록했어요!',
                    style: const TextStyle(
                        fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black
                    ),),
                ),
                const SizedBox(height: 30,),

                Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xff737373), width: 1,),
                            ),
                            child: Text(formattedTime, style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black
                            ),),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Container(
                              color: const Color(0xffE1E1E1),
                              height: 1,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                          width: width * 0.8,
                          child: Text(widget.name, style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          )
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(widget.img),
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
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RoutineScheduleMain()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(const Color(0xffFFC215)),
                minimumSize: WidgetStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
              child: const Text('하루 일과로 돌아가기', style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}
