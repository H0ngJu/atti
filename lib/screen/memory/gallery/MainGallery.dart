import 'dart:math';

import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/screen/memory/gallery/MemoryDetail.dart';
import 'package:atti/screen/memory/gallery/RecollectionDetail.dart';
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../data/auth_controller.dart';
import '../../../data/memory/memory_note_model.dart';
import '../../../data/memory/memory_note_service.dart';
import 'RecollectionData.dart';
import 'TagController.dart';

class MainGallery extends StatefulWidget {
  const MainGallery({Key? key}) : super(key: key);

  @override
  State<MainGallery> createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainGallery> {
  AuthController authController = Get.put(AuthController());
  MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  TagController tagController = Get.put(TagController());
  MemoryNoteService memoryNoteService = MemoryNoteService();
  List<MemoryNoteModel> memoryNotes = [];
  late int numberOfMemory;
  late RecollectionData randomData;

  // bottom Navi logic
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    randomData = dummyData[Random().nextInt(dummyData.length)];
  }

  Future<void> fetchData() async {
    List<MemoryNoteModel> fetchedNotes =
        await memoryNoteService.getMemoryNote();

    if (tagController.selectedTag.value == '옛날') {
      memoryNotes = fetchedNotes;

      memoryNotes.sort((a, b) {
        int eraA = a.era ?? 0;
        int eraB = b.era ?? 0;
        return eraA.compareTo(eraB);
      });
    } else {
      memoryNotes = fetchedNotes
          .where((memory) =>
              memory.keyword?.contains(tagController.selectedTag.value) ??
              false)
          .toList();
      memoryNotes.sort((a, b) {
        int eraA = a.era ?? 0;
        int eraB = b.era ?? 0;
        return eraA.compareTo(eraB);
      });
    }

    setState(() {
      //memoryNotes = fetchedNotes;
      numberOfMemory = memoryNotes.length;
      // if (memoryNotes.isNotEmpty) {
      //   print(memoryNotes[0].imgTitle);
      // } else {
      //   print('Memory notes is empty');
      // }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  Widget GalleryContent(memory) {
    return GestureDetector(
      onTap: () {
        Get.to(MemoryDetail(memory: memory));
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  '${memory.img}',
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '${memory.imgTitle}',
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children : <Widget>[SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.72,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                              text: '${authController.userName.value}님의\n'),
                          TextSpan(
                            text:
                                '\'${tagController.selectedTag.value}\' 기억을 모아봤어요',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(GalleryOption());
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black),
                      shape: CircleBorder(),
                      minimumSize: Size(48, 48),
                    ),
                    child: Text(
                      '나열\n변경',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              // 이미지를 중앙 정렬하기 위한 Row 위젯
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              children: [
                Image(
                    image: AssetImage('lib/assets/Atti/Stars.png'),
                    width: MediaQuery.of(context).size.width * 0.5),
              ],
            ),
            SizedBox(height: 10), // 간격을 추가하여 이미지와 텍스트를 구분
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xffFFC215),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Text(
                  '사진을 눌러\n그 시절에 대해 이야기해요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'UhBee', fontSize: 25)),
            ),
            // GridView를 사용하여 2열로 메모리 정보를 표시합니다.
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 30,
              ),
              itemCount: memoryNotes.length + 1, // 첫 번째 고정 아이템을 위해 +1을 합니다.
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // GridView가 스크롤되지 않도록 합니다.
              itemBuilder: (context, index) {
                // 첫 번째 아이템 처리
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                        Get.to(RecollectionDetail(data: randomData));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                '${randomData.img}',
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${randomData.title}',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // 그 외의 아이템 처리
                  MemoryNoteModel memory = memoryNotes[index - 1]; // 인덱스 조정
                  return GalleryContent(memory);
                }
              },
            ),

          ],
        ),
      ),Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Get.to(MemoryRegister1());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0, // 버튼의 그림자를 제거
                backgroundColor: Color(0xffFFC215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50), // 버튼의 크기 설정
              ),
              child: Text(
                '기억 추가하기',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretendardMedium',
                    fontSize: 24),
              ),
            ),
          ),
        ),]),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
