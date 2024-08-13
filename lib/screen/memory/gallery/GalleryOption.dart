import 'package:atti/screen/memory/gallery/MainGallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/memory/memory_note_controller.dart';
import '../../../data/memory/memory_note_model.dart';
import '../../../data/memory/memory_note_service.dart';
import 'TagController.dart';

class GalleryOption extends StatefulWidget {
  const GalleryOption({Key? key}) : super(key: key);

  @override
  State<GalleryOption> createState() => _GalleryOptionState();
}

class _GalleryOptionState extends State<GalleryOption> {
  MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  TagController tagController = Get.put(TagController());
  MemoryNoteService memoryNoteService = MemoryNoteService();
  List<MemoryNoteModel> memoryNotes = [];
  List<String> keywords = [];
  late int numberOfMemory;
  final List<String> tagList = ['옛날'];
  late String selectedTag = '';
  late bool showAllTags;

  @override
  void initState() {
    super.initState();
    fetchData();
    if (tagList.isNotEmpty) {
      selectedTag = tagList.first;
    }
    showAllTags = tagList.length <= 6;
  }

  Future<void> fetchData() async {
    List<MemoryNoteModel> fetchedNotes = await memoryNoteService.getMemoryNote();
    List<String> allKeywords = [];

    // 모든 메모에서 키워드를 추출하여 리스트에 추가
    fetchedNotes.forEach((memoryNote) {
      if (memoryNote.keyword != null) {
        allKeywords.addAll(memoryNote.keyword!);
      }
    });

    // 중복 제거를 위해 Set으로 변환 후 다시 리스트로 변환
    List<String> uniqueKeywords = allKeywords.toSet().toList();

    // tagList에 선택된 태그가 포함되어 있지 않으면 추가
    uniqueKeywords.forEach((keyword) {
      if (!tagList.contains(keyword)) {
        tagList.add(keyword);
      }
    });

    setState(() {
      memoryNotes = fetchedNotes;
      keywords = allKeywords;
      numberOfMemory = memoryNotes.length;
    });
  }

  Widget CurrentTag() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '현재 기억 단어',
            style: TextStyle(fontSize: 24),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Color(0xffFFF5DB), borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Text(
            '${tagController.selectedTag.value}',
            style: TextStyle(fontSize: 24, color: Color(0xffA38130)),
          ),
        )
      ],
    );
  }

  Widget NewTag() {
    return Column(
      children: [
        Container(
          child: Text(
            '변경할 기억 단어',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('사진 나열 변경'),
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xffB8B8B8),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                        text: '어떤 기억 단어로\n',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                      text: '사진을 다시 나열할까요?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                        text: '\n아래에서 선택해 주세요',
                        style: TextStyle(fontSize: 24, color: Color(0xff9F9F9F))),
                  ],
                ),
              ),
            ),
            Container(margin: EdgeInsets.all(16), child: CurrentTag()),
            Container(
              margin: EdgeInsets.all(16),
              child: NewTag(),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 15),
                child: SelectFamilyMemberButtons()),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(MainGallery());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFFC215),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                    ),
                    child: Text(
                      '사진 나열하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PretendardMedium',
                          fontSize: 24),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget SelectFamilyMemberButtons() {
    List<String> displayTags = showAllTags ? tagList.take(6).toList() : tagList;

    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          spacing: 10,
          // 가로 간격 설정
          runSpacing: 10,
          // 세로 간격 설정
          children: List.generate(displayTags.length, (index) {
            return TextButton(
              onPressed: () {
                setState(() {
                  selectedTag = displayTags[index];
                  tagController.selectedTag.value = selectedTag; // 선택된 태그를 업데이트합니다.
                });
              },
              child: Text(displayTags[index]),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(fontSize: 24, inherit: true), // inherit 속성 추가
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                    if (displayTags[index] == selectedTag) {
                      return Colors.white; // 선택됐을 때 텍스트 색상
                    } else {
                      return Colors.black; // 선택되지 않았을 때 텍스트 색상
                    }
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                    if (displayTags[index] == selectedTag) {
                      return Color(0xffFFC215); // 선택됐을 때 배경색
                    } else {
                      return Colors.white; // 선택되지 않았을 때 배경색
                    }
                  },
                ),
                side: MaterialStateProperty.resolveWith<BorderSide>(
                      (states) {
                    if (displayTags[index] == selectedTag) {
                      return BorderSide(color: Colors.white); // 선택됐을 때 테두리 색상 및 두께
                    } else {
                      return BorderSide(color: Colors.black, width: 1.0); // 선택되지 않았을 때
                    }
                  },
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(vertical: 10, horizontal: 18.0), // 버튼 내부 패딩 설정
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // 버튼 모서리 둥글기 설정
                  ),
                ),
              ),
            );
          }),
        ),
        // 토글 버튼 추가
        if (tagList.length > 6)
          TextButton(
            onPressed: () {
              setState(() {
                showAllTags = !showAllTags;
              });
            },
            child: Icon(
              showAllTags ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Color(0xffFFC215),
              size: 30,
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.zero,
              ),
            ),
          ),
      ],
    );
  }
}
