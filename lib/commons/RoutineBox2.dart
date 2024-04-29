import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../data/routine/routine_controller.dart';

class RoutineBox2 extends StatefulWidget {
  const RoutineBox2({super.key, required this.time, required this.name, required this.img,});
  final time;
  final name;
  final img;

  @override
  State<RoutineBox2> createState() => _RoutineBox2State();
}

class _RoutineBox2State extends State<RoutineBox2> {
  final RoutineController routineController = Get.put(RoutineController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xff737373), width: 1,),
                ),
                child: Text(widget.time, style: TextStyle(fontSize: 22),),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Container(
                  color: Color(0xffE1E1E1),
                  height: 1,
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text(widget.name, style: TextStyle(fontSize: 30),),
          SizedBox(height: 5,),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
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
        ],
      ),
    );
  }
}
