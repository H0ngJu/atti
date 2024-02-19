import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/notification/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NoticeMain extends StatefulWidget {
  const NoticeMain({Key? key}) : super(key: key);

  @override
  State<NoticeMain> createState() => _NoticeMainState();
}

class _NoticeMainState extends State<NoticeMain> {
  final AuthController authController = Get.put(AuthController());
  List<NotificationModel> todayNotifications = [];
  List<NotificationModel> pastNotifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  // 알림 데이터 불러오기
  void fetchNotifications() async {
    try {
      // 현재 사용자의 UID 가져오기
      String? userUid = authController.loggedUser;

      if (userUid != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('notification')
            .where('uid', isEqualTo: userUid) // 현재 사용자의 UID로 필터링
            .get();

        DateTime now = DateTime.now();
        print('here');
        List<NotificationModel> allNotifications = querySnapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        todayNotifications = allNotifications
            .where((notification) => isSameDay(notification.time!.toDate(), now))
            .toList();

        pastNotifications = allNotifications
            .where((notification) => notification.time!.toDate().isBefore(now))
            .toList();
        print('there : ${pastNotifications.isNotEmpty ? pastNotifications.first.time : 'No notifications found'}');
      } else {
        print('User is not logged in.'); // 현재 사용자가 로그인되어 있지 않은 경우
      }

      setState(() {}); // 상태를 업데이트하여 화면을 다시 그립니다.
    } catch (e) {
      print('Failed to fetch notifications: $e');
    }
  }


  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }


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
            TodayNotice(notifications: todayNotifications),
            SizedBox(height: 30,),
            PastNotice(notifications : pastNotifications),
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
  final NotificationModel notifications;

  const TodayNoticeContainer({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = notifications.time != null ? _formatTimestamp(notifications.time!) : '';
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xffFFE9B3), borderRadius: BorderRadius.circular(15)),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffFFC215), width: 2),
              color: noti.done ? Color(0xffFFC215) : Color(0xffFFE9B3),
              shape: BoxShape.circle,
            ),
          ),*/
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
                    '${notifications.title}   ${formattedTime}',
                    style: TextStyle(fontSize: 16, color: Color(0xffA38130)),
                  ),
                  Text(
                    '${notifications.message}',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ))
        ],
      ),
    );
  }
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일'; // 연도, 월, 일을 문자열로 변환
    String period = dateTime.hour < 12 ? '오전' : '오후';
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;

    String formattedTime = '$period ${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$formattedDate $formattedTime';
  }
}

class TodayNotice extends StatefulWidget {
  final List<NotificationModel> notifications;
  const TodayNotice({Key? key, required this.notifications}) : super(key: key);

  @override
  State<TodayNotice> createState() => _TodayNoticeState();
}

class _TodayNoticeState extends State<TodayNotice> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '오늘 받은 알림  ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${widget.notifications.length}',
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
          itemCount: widget.notifications.length,
          itemBuilder: (context, index) {
            return TodayNoticeContainer(notifications: widget.notifications[index]); // Pass individual notification item
          },
        ),
      ],
    );
  }
}

class PastNoticeContainer extends StatelessWidget {
  final NotificationModel notifications;

  const PastNoticeContainer({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = notifications.time != null ? _formatTimestamp(notifications.time!) : '';
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /*Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              color: noti.done ? Colors.grey : Colors.grey[200],
              shape: BoxShape.circle,
            ),
          ),*/
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
                    '${notifications.title}   ${formattedTime}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                  Text(
                    '${notifications.message}',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ))
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일'; // 연도, 월, 일을 문자열로 변환
    String period = dateTime.hour < 12 ? '오전' : '오후';
    int hour = dateTime.hour % 12;
    if (hour == 0) hour = 12;

    String formattedTime = '$period ${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$formattedDate $formattedTime';
  }
}

class PastNotice extends StatefulWidget {
  final List<NotificationModel> notifications;
  const PastNotice({Key? key, required this.notifications}) : super(key: key);

  @override
  State<PastNotice> createState() => _PastNoticeState();
}

class _PastNoticeState extends State<PastNotice> {
  String selectedCategory = '전체'; // 선택된 카테고리
  late List<NotificationModel> filteredData = _filterDataByCategory(selectedCategory);
  //late List<NotificationModel> originData;
  List<String> allCategories = ['전체', '하루일과', '일정'];

  @override
  void initState() {
    super.initState();
    filteredData = _filterDataByCategory(selectedCategory);
    print('${widget.notifications}');
    //originData = widget.notifications;
  }

  List<NotificationModel> _filterDataByCategory(String category) {
    if (category == '전체') {
      return widget.notifications;
    } else {
      return widget.notifications.where((notification) {
        if (category == '하루일과') {
          return notification.title == '하루 일과 알림';
        } else if (category == '일정') {
          return notification.title == '일정 알림';
        }
        return false;
      }).toList();
    }
  }


  @override
  Widget build(BuildContext context) {
    //List<NotificationModel> filteredData = _filterDataByCategory(selectedCategory);
    //print('Filtered Data: $_filterDataByCategory(category)'); // filteredData 값을 출력
    //print('total : ${originData.first.message}');
    return Column(
      children: [
        Row(
          children: [
            Text(
              '이전에 받은 알림  ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${widget.notifications.length}',
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
                      filteredData = _filterDataByCategory(category);
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
          itemCount: filteredData!.length,
          itemBuilder: (context, index) {
            return PastNoticeContainer(notifications: filteredData[index]);
          },
        ),
      ],
    );
  }
}


