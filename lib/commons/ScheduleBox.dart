// 일정 박스 UI (시간, 이름, 장소)
// 사용법 :
// ScheduleBox(
//                   time: scheduleController.time.value,
//                   name: scheduleController.name.value,
//                   location: scheduleController.location.value,
//                 ),
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleBox extends StatefulWidget {
  const ScheduleBox({super.key, this.time, this.name, this.location, this.isFinished});
  final time;
  final name;
  final location;
  final isFinished;

  @override
  State<ScheduleBox> createState() => _ScheduleBoxState();
}

class _ScheduleBoxState extends State<ScheduleBox> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xff737373), width: 1,),
                ),
                child: Text(widget.time, style: TextStyle(
                  fontSize: 22,
                  color: widget.isFinished ? Color(0xff868686) : Colors.black,
                ),
                ),
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
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 15),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(0xffDDDDDD), width: 1,),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.name != null) Text(widget.name!, style: TextStyle(
                  fontSize: 30,
                  color: widget.isFinished ? Color(0xff868686) : Colors.black,
                ),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('장소', style: TextStyle(
                      fontSize: 20,
                      color: widget.isFinished ? Color(0xff868686) : Colors.black,
                    ),),
                    SizedBox(width: 10),
                    if (widget.location != null) Text(widget.location!, style: TextStyle(
                      fontSize: 20,
                      color: widget.isFinished ? Color(0xff868686) : Colors.black,
                    ),),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
