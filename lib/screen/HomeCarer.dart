import 'package:atti/commons/AttiAppBar.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class User {
  final String? name;
  final int? incompleteRoutineCount;
  final int? momoryRegistCount;
  final String? emotion;
  final String? mostMemory;

  User({
    this.name,
    this.emotion,
    this.incompleteRoutineCount,
    this.mostMemory,
    this.momoryRegistCount,
  });
}

class HomeCarer extends StatefulWidget {
  const HomeCarer({Key? key}) : super(key: key);

  @override
  _HomeCarerState createState() => _HomeCarerState();
}

class _HomeCarerState extends State<HomeCarer> {
  // bottom Navi logic
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  // 사용자 dummy
  final List<User> dummy = [
    User(
      name: '최한별',
      emotion: '즐거움',
      momoryRegistCount: 5,
      mostMemory: '제주도 여행',
      incompleteRoutineCount: 3,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: HomePatientTop(dummy: dummy)),
            Container(margin: EdgeInsets.all(16), child: HomeTodaySummary()),
            Container(
              margin: EdgeInsets.all(16),
              child: HomeReport(dummy: dummy, context: context),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// 메인 첫 화면
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
                  text: '${user.name} 보호자님\n',
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

// 오늘의 일정, 일과
class HomeTodaySummary extends StatefulWidget {
  const HomeTodaySummary({Key? key}) : super(key: key);

  @override
  State<HomeTodaySummary> createState() => _HomeTodaySummaryState();
}

class _HomeTodaySummaryState extends State<HomeTodaySummary> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 132,
            // 정적으로 고정할 것인가?
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 그림자 색상 및 불투명도 설정
                  spreadRadius: 2, // 그림자의 확산 범위
                  blurRadius: 7, // 그림자의 흐림 정도
                  offset: Offset(2, 2), // 그림자의 위치 (가로, 세로)
                ),
              ], // 테두리 추가
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    TextStyle(color: Colors.black, fontSize: 24, height: 1.5),
                children: [
                  TextSpan(text: '예정된 일정\n'),
                  TextSpan(
                      text: '2개',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFC215))),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 132,
            // 정적으로 고정할 것인가?
            margin: EdgeInsets.only(left: 8),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 그림자 색상 및 불투명도 설정
                  spreadRadius: 2, // 그림자의 확산 범위
                  blurRadius: 7, // 그림자의 흐림 정도
                  offset: Offset(2, 2), // 그림자의 위치 (가로, 세로)
                ),
              ], // 테두리 추가
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style:
                    TextStyle(color: Colors.black, fontSize: 24, height: 1.5),
                children: [
                  TextSpan(text: '오늘의 일과\n'),
                  TextSpan(
                      text: '4개',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFFC215))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeReport extends StatelessWidget {
  final List<User> dummy;
  final BuildContext context;

  const HomeReport({Key? key, required this.dummy, required this.context})
      : super(key: key);

  Widget ContentCircle(insideCircle, title1, title2) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                    color: Color(0xffFFC215),
                    style: BorderStyle.solid,
                    width: 4)),
            child: Text(
              '${insideCircle}',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              maxLines: 2,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${title1}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${title2}',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = dummy[0];
    final now = DateTime.now();
    final weekOfMonth = getWeekOfMonth(now);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${now.month}월 ${weekOfMonth}주차 기록 보고',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  '전체보기',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFFC215),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Container(
            child: Text(
              '${now.year}.${now.month}.${now.day} ~ ${now.year}.${now.month}.${now.day}',
              style: TextStyle(fontSize: 24, color: Color(0xffB3B3B3)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContentCircle(user.incompleteRoutineCount, '미완료', '완료'),
                ContentCircle(user.momoryRegistCount, '기억', '등록'),
                ContentCircle(user.emotion, '회상', '감정'),
                ContentCircle(user.mostMemory, '최다', '열람기억')
              ],
            ),
          )
        ],
      ),
    );
  }

  int getWeekOfMonth(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final weekdayOfFirstDay = firstDayOfMonth.weekday;
    final firstSunday =
        firstDayOfMonth.subtract(Duration(days: weekdayOfFirstDay - 1));
    final difference = date.difference(firstSunday).inDays;
    final weekNumber = (difference / 7).ceil();
    return weekNumber;
  }
}
