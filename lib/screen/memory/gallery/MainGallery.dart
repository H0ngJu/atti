import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/screen/memory/gallery/MemoryDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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

  Widget GalleryContent(info) {
    return GestureDetector(
      onTap: () {Get.to(MemoryDetail());},
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  '${info.url}',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '${info.name}',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = dummy[0];
    List<MemoryInfo>? memories = user.memory;
    return Scaffold(
      backgroundColor: Color(0xffFFF5DB),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: '${user.name}님의\n'),
                        TextSpan(
                          text: '\'${user.tagName}\'기억을 모아봤어요',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(GalleryOption());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFFC215),
                      shape: CircleBorder(),
                      minimumSize: Size(48, 48),
                    ),
                    child: Text(
                      '순서\n변경',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // GridView를 사용하여 2열로 메모리 정보를 표시합니다.
            GridView.count(
              crossAxisCount: 2,
              // 열의 수를 2로 설정합니다.
              crossAxisSpacing: 16,
              // 열 간의 간격을 조정합니다.
              mainAxisSpacing: 30,
              // 행 간의 간격을 조정합니다.
              shrinkWrap: true,
              // GridView가 SingleChildScrollView와 함께 사용될 때 필요합니다.
              physics: NeverScrollableScrollPhysics(),
              // GridView가 스크롤되지 않도록 합니다.
              children: memories!.map((memory) {
                return GalleryContent(memory);
              }).toList(),
            ),
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
