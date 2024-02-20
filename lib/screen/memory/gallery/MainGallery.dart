import 'package:atti/commons/AttiBottomNavi.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/screen/memory/gallery/MemoryDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../data/auth_controller.dart';
import '../../../data/memory/memory_note_model.dart';
import '../../../data/memory/memory_note_service.dart';
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

  // bottom Navi logic
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
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
                                '\'${tagController.selectedTag.value}\'기억을 모아봤어요',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
              children: memoryNotes!.map((memory) {
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
