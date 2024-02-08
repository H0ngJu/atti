import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User {
  final String? name;
  final String? tagName; // Changed the name to routineCount
  final List<MemoryInfo>? memory;

  User({this.name, this.tagName, this.memory});
}

class MemoryInfo {
  final String? name;
  final String? url;

  MemoryInfo({this.name, this.url});
}

class MainGallery extends StatefulWidget {
  const MainGallery({Key? key}) : super(key: key);

  @override
  State<MainGallery> createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainGallery> {
  // bottom Navi logic
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  final List<User> dummy = [
    User(
      name: '최한별',
      tagName: '옛날',
      memory: [
        MemoryInfo(
          name: '중학교 졸업',
          url:
              'https://dimg.donga.com/wps/NEWS/IMAGE/2022/02/18/111894898.1.jpg',
        ),
        MemoryInfo(
          name: '내 고향',
          url:
          'https://cdn.lecturernews.com/news/photo/202308/133402_377232_2037.png',
        ),
        MemoryInfo(
          name: '아버지 유품',
          url:
          'https://mblogthumb-phinf.pstatic.net/20160425_60/upup23_1461558270098iGYoi_JPEG/%BF%BE%B3%AF%BB%E7%C1%F8%2C%BB%E7%C1%F8%BA%B9%BF%F8_%281%29.jpg?type=w800',
        ),
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    User user = dummy[0];
    return Scaffold(
      backgroundColor: Color(0xffFFF5DB),
      body: SingleChildScrollView(padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top:20),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, fontSize: 24, height: 1.5),
                      children: [
                        TextSpan(text: '${user.name}님의\n'),
                        TextSpan(
                            text:
                                '\'${user.tagName}\'기억을 모아봤어요',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
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
