import 'dart:math';

import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/tmp/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/tmp/screen/memory/gallery/MemoryDetail.dart';
import 'package:atti/tmp/screen/memory/gallery/RecollectionDetail.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../../../../data/auth_controller.dart';
import '../../../../data/memory/memory_note_model.dart';
import '../../../../data/memory/memory_note_service.dart';
import '../../../../data/memory/RecollectionData.dart';
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
    _speak();
  }

  FlutterTts flutterTts = FlutterTts();

  Future _speak() async {
    var result = await flutterTts.speak("사진을 눌러 그 시절에 대해 이야기해요");
    await flutterTts.setLanguage('ko-KR');
    await flutterTts.setPitch(1);
    if (result == 1) {
      // 성공적으로 재생
    } else {
      // 재생 실패
    }
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
                style: const TextStyle(fontSize: 24),
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
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.72,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
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
                              style: const TextStyle(
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
                        Get.to(const GalleryOption());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                        shape: const CircleBorder(),
                        minimumSize: const Size(48, 48),
                      ),
                      child: const Text(
                        '나열\n변경',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                // 이미지를 중앙 정렬하기 위한 Row 위젯
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                children: [
                  Image(
                      image: const AssetImage('lib/assets/Atti/Stars.png'),
                      width: MediaQuery.of(context).size.width * 0.46),
                ],
              ),
              const SizedBox(height: 10), // 간격을 추가하여 이미지와 텍스트를 구분
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Color(0xffFFC215),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: const Text('사진을 눌러\n그 시절에 대해 이야기해요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'UhBee',
                        fontSize: 25)),
              ),
              // GridView를 사용하여 2열로 메모리 정보를 표시합니다.
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 30,
                ),
                itemCount: memoryNotes.length + 1,
                // 첫 번째 고정 아이템을 위해 +1을 합니다.
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // GridView가 스크롤되지 않도록 합니다.
                itemBuilder: (context, index) {
                  // 첫 번째 아이템 처리
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(RecollectionDetail(data: randomData));
                      },
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xffFFC215),
                                  width: 5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.saturation,
                                  ),
                                  child: Image.network(
                                    randomData.img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 15, // 별 아이콘의 위쪽 여백
                              left: 15, // 별 아이콘의 왼쪽 여백
                              child: Icon(
                                Icons.star_rate_rounded, // 별 모양 아이콘
                                color: Color(0xffFFC215), // 별 아이콘 색상
                                size: 37, // 별 아이콘 크기
                              ),
                            ),
                          ])),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              randomData.title,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 그 외의 아이템 처리
                    MemoryNoteModel memory = memoryNotes[index - 1]; // 인덱스 조정
                    return GalleryContent(memory);
                  }
                },
              ),

              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                Get.to(const MemoryRegister1());
              },
              style: ElevatedButton.styleFrom(
                elevation: 0, // 버튼의 그림자를 제거
                backgroundColor: const Color(0xffFFC215),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.9, 50), // 버튼의 크기 설정
              ),
              child: const Text(
                '기억 추가하기',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PretendardMedium',
                    fontSize: 24),
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
