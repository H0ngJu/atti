import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/patient/screen/memory/chat/ChatScreen.dart';
import 'package:atti/patient/screen/memory/chat/ChatHistory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/memory/memory_note_model.dart';
import '../../../../commons/AttiBottomNavi.dart';

class MemoryInfo extends StatefulWidget {
  final MemoryNoteModel memory;
  final List<MemoryNoteModel> albumList;
  final bool isEditMode;

  const MemoryInfo({Key? key, required this.memory, required this.albumList, required this.isEditMode})
      : super(key: key);

  @override
  State<MemoryInfo> createState() => _MemoryInfoState();
}

class _MemoryInfoState extends State<MemoryInfo> {
  late int currentIndex;
  late int _selectedIndex = 0;
  late MemoryNoteModel currentMemory;

  @override
  void initState() {
    super.initState();
    currentMemory = widget.memory;
    currentIndex = widget.albumList.indexOf(currentMemory);
  }

  void navigateToMemory(int index) {
    setState(() {
      currentIndex = index;
      currentMemory = widget.albumList[currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentIndex > 0;
    final canGoNext = currentIndex < widget.albumList.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SimpleAppBar(title: '기억 한 조각'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      currentMemory.img ?? '',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MemoryDetailTitle(canGoNext, canGoBack),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                FamilyWords(memory: currentMemory),
                const SizedBox(
                  height: 10,
                ),
                MemoryWords(memory: currentMemory),
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              widget.isEditMode
              ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: TextButton(
                  onPressed: () {
                    Get.to(ChatHistory(memory: currentMemory));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff262626)),
                  child: const Text(
                    '회상 대화 기록 보기',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              )
              : SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: TextButton(
                  onPressed: () {
                    Get.to(ChatScreen(memory: currentMemory, albumList: widget.albumList,));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFC215)),
                  child: const Text(
                    '아띠와 대화하기',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget MemoryDetailTitle(bool canGoNext, bool canGoBack) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canGoBack)
            TextButton(
              onPressed: () => navigateToMemory(currentIndex - 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEDEDED),
              ),
              child: const Text('이전',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'PretendardRegular')),
            )
          else
            SizedBox(width: MediaQuery.of(context).size.width * 0.15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${currentMemory.era}년대',
                style: const TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
              ),
              Text(
                '${currentMemory.imgTitle}',
                style: const TextStyle(fontSize: 30, fontFamily: 'PretendardMedium'),
              ),
            ],
          ),
          if (canGoNext)
            TextButton(
              onPressed: () => navigateToMemory(currentIndex + 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEDEDED),
              ),
              child: const Text('다음',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'PretendardRegular')),
            )
          else
            SizedBox(width: MediaQuery.of(context).size.width * 0.15),
        ]);
  }
}

class FamilyWords extends StatelessWidget {
  final MemoryNoteModel memory;

  const FamilyWords({Key? key, required this.memory}) : super(key: key);

  Widget TagContainer(String tag) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(width: 0.7, color: const Color(0xff868686)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagList = memory.selectedFamilyMember ?? [];

    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '함께한 사람',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'PretendardRegular',
            ),
          ),
          Wrap(
            spacing: 10,
            children: tagList.map(TagContainer).toList(),
          ),
        ],
      ),
    );
  }
}

class MemoryWords extends StatelessWidget {
  final MemoryNoteModel memory;

  const MemoryWords({Key? key, required this.memory}) : super(key: key);

  Widget TagContainer(String tag) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      decoration: BoxDecoration(
        color: const Color(0xffFFEFC6),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagList = memory.keyword ?? [];

    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기억단어 보기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'PretendardRegular',
            ),
          ),
          Wrap(
            spacing: 10,
            children: tagList.map(TagContainer).toList(),
          ),
        ],
      ),
    );
  }
}
