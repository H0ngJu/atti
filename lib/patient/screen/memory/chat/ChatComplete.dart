import 'package:atti/patient/screen/memory/gallery/MemoryInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../../../carer/screen/memory/gallery/CarerMainMemory.dart';
import '../../../../data/auth_controller.dart';
import '../../../../data/memory/memory_note_controller.dart';
import '../../../../data/memory/memory_note_model.dart';
import '../../../../data/memory/memory_note_service.dart';
import 'package:atti/patient/screen/memory/gallery/MainMemory.dart';

class ChatComplete extends StatefulWidget {
  final MemoryNoteModel memory;
  final List<MemoryNoteModel> albumList;

  const ChatComplete({Key? key, required this.memory, required this.albumList})
      : super(key: key);

  @override
  _ChatCompleteState createState() => _ChatCompleteState();
}

class _ChatCompleteState extends State<ChatComplete> {
  AuthController authController = Get.put(AuthController());
  MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  MemoryNoteService memoryNoteService = MemoryNoteService();
  List<MemoryNoteModel> memoryNotes = [];
  late int numberOfMemory;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<MemoryNoteModel> fetchedNotes =
        await memoryNoteService.getMemoryNote();

    memoryNotes = fetchedNotes;

    setState(() {
      numberOfMemory = memoryNotes.length;
    });
  }

  Widget GalleryContent(memory) {
    return GestureDetector(
      onTap: () {
        Get.to(MemoryInfo(memory: memory, albumList: widget.albumList, isEditMode: false));
      },
      child: Container(
        child: Column(
          children: [
            Container(
              height: 150, // 고정 높이 지정
              width: 150, // 고정 너비 지정
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  '${memory.img}',
                  fit: BoxFit.cover,
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
    List<MemoryNoteModel> randomMemoryNotes =
        selectRandomMemoryNotes(memoryNotes, 4); // 기억 랜덤하게 3개 뽑기

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.07,
              left: 16,
              right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  '\'${this.widget.memory.imgTitle}\' 대화 기록이\n저장되었어요!',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontFamily: 'PretendardMedium'),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                child: Text(
                  '다른 기억도 열람해보세요!',
                  style:
                      TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
                ),
              ),
              SizedBox(height: 20,),
              // 기존의 GalleryContent(memoryNotes[0]), 부분을 아래의 코드로 대체하세요.
              if (randomMemoryNotes.length >= 2)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: GalleryContent(randomMemoryNotes[0])),
                        SizedBox(width: 16), // 간격 조정
                        Expanded(child: GalleryContent(randomMemoryNotes[1])),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: GalleryContent(randomMemoryNotes[2])),
                        SizedBox(width: 16), // 간격 조정
                        Expanded(child: GalleryContent(randomMemoryNotes[3])),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: 80),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: TextButton(
                  onPressed: () {
                    if (authController.isPatient) {
                      Get.to(() => MainMemory());
                    } else {
                      Get.to(() => CarerMainMemory());
                    }
                  },
                  style:
                      TextButton.styleFrom(backgroundColor: Color(0xffFFC215)),
                  child: Text(
                    '내 기억으로 돌아가기',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 주어진 리스트에서 랜덤으로 n개의 항목을 선택하는 함수
  List<MemoryNoteModel> selectRandomMemoryNotes(
      List<MemoryNoteModel> notes, int n) {
    var random = math.Random();
    // 리스트의 길이가 n보다 작거나 같으면 전체 리스트 반환
    if (notes.length <= n) {
      return List.from(notes);
    }
    // 랜덤으로 n개의 항목 선택
    var randomNotes = <MemoryNoteModel>[];
    var usedIndexes = <int>{};
    while (randomNotes.length < n) {
      int index = random.nextInt(notes.length);
      if (!usedIndexes.contains(index)) {
        randomNotes.add(notes[index]);
        usedIndexes.add(index);
      }
    }
    return randomNotes;
  }
}
