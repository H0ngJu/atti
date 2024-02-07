import 'package:atti/commons/AttiAppBar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  // 사용자 dummy
  final List<User> dummy = [
    User(
      name: '최한별',
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
      backgroundColor: Color(0xffFFF5DB),
      appBar: AttiAppBar(
        title: Image.asset(
          'lib/assets/logo2.png',
          width: 150,
        ),
        showNotificationsIcon: true,
        showPersonIcon: true,
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: HomePatientTop(dummy: dummy)),
        ],
      ),
    );
  }
}

class HomePatientTop extends StatefulWidget {
  final List<User> dummy; // 수정된 부분: dummy 데이터를 받기 위한 변수 선언

  const HomePatientTop({Key? key, required this.dummy}) : super(key: key);

  @override
  State<HomePatientTop> createState() => _HomePatientTopState();
}

class _HomePatientTopState extends State<HomePatientTop> {
  @override
  Widget build(BuildContext context) {
    User user = widget.dummy[0]; // user dummy 전달
    // 시간 가져오기
    DateTime now = DateTime.now();
    String weekday = _getWeekday(now.weekday);

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 열을 위에서부터 시작하도록 정렬
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯을 왼쪽 정렬
        children: [
          SizedBox(height: 25),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, height: 1.2),
              children: [
                TextSpan(
                  text: '${user.name}\n',
                  style: TextStyle(fontSize: 24),
                ),
                TextSpan(
                  text: '안녕하세요?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
          ),
          SizedBox(height: 14), // 간격을 추가하여 텍스트와 이미지를 구분
          Row(
            // 이미지를 중앙 정렬하기 위한 Row 위젯
            mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
            children: [
              Image(
                  image: AssetImage('lib/assets/standingAtti.png'), width: 320),
            ],
          ),
          SizedBox(height: 10), // 간격을 추가하여 이미지와 텍스트를 구분
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 24, height: 1.2),
              children: [
                TextSpan(text: '오늘은\n'),
                TextSpan(
                    text: '${now.year}년 ${now.month}월 ${now.day}일 ${weekday}',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                TextSpan(text: ' 이에요.'),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // 요일을 반환하는 함수
  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }
}
