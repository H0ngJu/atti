// 일정 박스 UI (시간, 이름, 장소)
// 사용법 :
// ScheduleBox(
//                   time: scheduleController.time.value,
//                   name: scheduleController.name.value,
//                   location: scheduleController.location.value,
//                 ),
import 'package:flutter/material.dart';

class ScheduleBox extends StatefulWidget {
  const ScheduleBox({super.key, this.time, this.name, this.location});
  final time;
  final name;
  final location;

  @override
  State<ScheduleBox> createState() => _ScheduleBoxState();
}

class _ScheduleBoxState extends State<ScheduleBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffFFE9B3),
        borderRadius: BorderRadius.circular(20),
        //border: Border.all(color: Colors.red, width: 2,),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.time, style: TextStyle(
            fontSize: 20
          ),),
          Text(widget.name, style: TextStyle(
            fontSize: 30,
          ),),
          SizedBox(height: 10,),
          Row(
            children: [
              Icon(Icons.location_on_outlined),
              SizedBox(width: 5),
              Text(widget.location, style: TextStyle(
                fontSize: 20
              ),),
            ],
          ),
        ],
      ),
    );
  }
}
