import 'package:atti/commons/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class NoticeMain extends StatefulWidget {
  const NoticeMain({Key? key}) : super(key: key);

  @override
  State<NoticeMain> createState() => _NoticeMainState();
}

class _NoticeMainState extends State<NoticeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: '알림',
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            TodayNotice(),
            SizedBox(height: 30,),
            PastNotice(),
          ],
        ),
      )),
    );
  }
}

class Noti {
  String title;
  String time;
  String category;
  bool done;

  Noti({
    required this.title,
    required this.time,
    required this.category,
    this.done = false,
  });
}

class TodayNoticeContainer extends StatelessWidget {
  final Noti noti;

  const TodayNoticeContainer({Key? key, required this.noti}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xffFFE9B3), borderRadius: BorderRadius.circular(15)),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffFFC215), width: 2),
              color: noti.done ? Color(0xffFFC215) : Color(0xffFFE9B3),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${noti.category}   ${noti.time}',
                    style: TextStyle(fontSize: 16, color: Color(0xffA38130)),
                  ),
                  Text(
                    '잠시후 \'${noti.time}\'에\n\'${noti.title}\'(이)가 있어요!',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class TodayNotice extends StatefulWidget {
  const TodayNotice({Key? key}) : super(key: key);

  @override
  State<TodayNotice> createState() => _TodayNoticeState();
}

class _TodayNoticeState extends State<TodayNotice> {
  @override
  Widget build(BuildContext context) {
    List<Noti> dummyData = [
      Noti(title: '새로운 알림', time: '09:00', category: '기억회상', done: false),
      Noti(title: '미팅 일정', time: '10:30', category: '하루일과', done: false),
      Noti(
        title: '과제 마감',
        time: '18:00',
        category: '일정',
        done: true,
      ),
      Noti(
        title: '추가',
        time: '18:00',
        category: '일정',
        done: true,
      ),
    ];
    return Column(
      children: [
        Row(
          children: [
            Text(
              '오늘 받은 알림  ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${dummyData.length}',
              style: TextStyle(fontSize: 24, color: Color(0xffFFC215)),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dummyData.length,
          itemBuilder: (context, index) {
            return TodayNoticeContainer(noti: dummyData[index]);
          },
        ),
      ],
    );
  }
}

class PastNoticeContainer extends StatelessWidget {
  final Noti noti;

  const PastNoticeContainer({Key? key, required this.noti}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              color: noti.done ? Colors.grey : Colors.grey[200],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${noti.category}   ${noti.time}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                  Text(
                    '잠시후 \'${noti.time}\'에\n\'${noti.title}\'(이)가 있어요!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class PastNotice extends StatefulWidget {
  const PastNotice({Key? key}) : super(key: key);

  @override
  State<PastNotice> createState() => _PastNoticeState();
}

class _PastNoticeState extends State<PastNotice> {
  String selectedCategory = '전체'; // 선택된 카테고리
  List<Noti> filteredData = [];
  List<String> allCategories = ['전체', '하루일과', '일정'];
  List<Noti> dummyData = [
    Noti(title: '새로운 알림', time: '09:00', category: '기억회상', done: false),
    Noti(title: '미팅 일정', time: '10:30', category: '하루일과', done: false),
    Noti(title: '과제 마감', time: '18:00', category: '일정', done: true),
    Noti(title: '추가', time: '18:00', category: '일정', done: true),
  ];

  @override
  void initState() {
    super.initState();
    filteredData = _filterDataByCategory(selectedCategory);
  }

  List<Noti> _filterDataByCategory(String category) {
    if (category == '전체') {
      return dummyData;
    } else {
      return dummyData.where((noti) => noti.category == category).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '이전에 받은 알림  ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${filteredData.length}',
              style: TextStyle(fontSize: 24, color: Color(0xffFFC215)),
            )
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: allCategories.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedCategory = category;
                      filteredData = _filterDataByCategory(selectedCategory);
                    }
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: Color(0xffFFC215),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            return PastNoticeContainer(noti: filteredData[index]);
          },
        ),
      ],
    );
  }
}

