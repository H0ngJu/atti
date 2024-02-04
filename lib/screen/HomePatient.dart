import 'package:atti/commons/AttiAppBar.dart';
import 'package:flutter/material.dart';

class User {
  final String? name;
  final int? routine;
  final List<Schedule>? schedule;
  final String? routineName;
  final String? routineTime;
  final String? routineImgUrl;
  final String? scheduleName;
  final String? scheduleTime;

  User(
      {this.name,
      this.routine,
      this.routineImgUrl,
      this.routineName,
      this.routineTime,
      this.schedule,
      this.scheduleName,
      this.scheduleTime});
}

class Schedule {
  final String? name;
  final String? time;
  final bool? done;

  Schedule({
    this.name,
    this.time,
    this.done,
  });
}

class HomePatient extends StatefulWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  _HomePatientState createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatient> {
  final List<User> dummyUsers = [
    User(
      name: 'John Doe',
      routine: 4,
      routineName: '약 복용하기',
      routineTime: '8:00 AM',
      routineImgUrl:
          'https://mblogthumb-phinf.pstatic.net/MjAxODA2MDNfNTMg/MDAxNTI4MDMzMDg3Mjk3.uawygqJVJ63TIzibG82yUkZxIUNpRKbpuM-0O1kl6oAg.iTqCtuOrXnj7OjOdz5K-wyVAwhO5dOBn2JKXSU-9S4og.JPEG.hanulmom84/image_5521562981528032119580.jpg?type=w800',
      schedule: [
        Schedule(
          name: '가족모임',
          time: '오후 5시',
          done: true,
        ),
        Schedule(
          name: '가족모임',
          time: '오후 5시',
          done: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AttiAppBar(
          title: Image.asset(
            'lib/assets/logo2.png',
            width: 150,
          ),
          showNotificationsIcon: true,
          showPersonIcon: true,
        ),
        body: Container(
            child: Text('Hello',
                style: TextStyle(fontSize: 24, color: Colors.black))));
  }
}
