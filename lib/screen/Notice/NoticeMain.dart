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
      appBar: SimpleAppBar(title: '알림',),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              TodayNotice(),
            ],
          ),
        )
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
    return Column(
      children: [Row(
        children: [
          Text('오늘 받은 알림')
        ],
      )],
    );
  }
}

