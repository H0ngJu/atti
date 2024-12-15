import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/data/memory/memory_note_service.dart';
import 'package:atti/patient/screen/memory/AddButton.dart';
import 'package:atti/tmp/screen/memory/gallery/MemoryDetail.dart';
import 'package:atti/commons/AttiBottomNavi.dart';

class MainMemory extends StatefulWidget {
  const MainMemory({Key? key}) : super(key: key);

  @override
  State<MainMemory> createState() => _MainGalleryState();
}

class _MainGalleryState extends State<MainMemory>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final MemoryNoteService memoryNoteService = MemoryNoteService();
  final FlutterTts flutterTts = FlutterTts();

  late TabController _tabController;
  Map<String, List<MemoryNoteModel>> groupedNotes = {};
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchData();
    _speak();
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage('ko-KR');
    await flutterTts.setPitch(1);
    await flutterTts.speak("사진을 눌러 그 기억에 대해 이야기해요");
  }

  void _onTabChanged() {
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 해당 인덱스로 페이지 변경
    });
  }

  Future<void> fetchData() async {
    List<MemoryNoteModel> fetchedNotes =
        await memoryNoteService.getMemoryNote();
    _groupNotes(fetchedNotes);
  }

  void _groupNotes(List<MemoryNoteModel> notes) {
    setState(() {
      if (_tabController.index == 0) {
        groupedNotes =
            groupBy(notes, (memory) => memory.era?.toString() ?? '기타'); // era 데이터가 없는 경우 예외 처리
      } else if (_tabController.index == 1) {
        groupedNotes = {};
        for (var memory in notes) {
          memory.selectedFamilyMember?.forEach((member, isSelected) {
            if (isSelected) { // 로직 확인 해야 됨
              groupedNotes.putIfAbsent(member, () => []).add(memory);
            }
          });
        }
      } else {
        groupedNotes = {'좋아하는 기억': notes};
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(height: 20),
                      _buildImageSection(),
                      SizedBox(height: 20),
                      _buildSpeechBubble(),
                      _buildCategoryTabs(),
                      Container(child: _buildGroupedMemoryCards()),
                    ],
                  )),
              Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.2,
                  //left: 0,
                  right: 0,
                  child: AddButton())
            ]),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 16),
        child: Container(
            //margin: EdgeInsets.only(top: 20),
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
                    TextSpan(text: '${authController.userName.value}님의\n'),
                    TextSpan(
                      text: '소중한 기억을 모아봤어요',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }

  Widget _buildImageSection() {
    return Row(
      // 이미지를 중앙 정렬하기 위한 Row 위젯
      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
      children: [
        Image(
            image: AssetImage('lib/assets/Atti/Stars.png'),
            width: MediaQuery.of(context).size.width * 0.46),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0xffFFEFC6),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Text('사진을 눌러\n그 기억에 대해 이야기해요',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontFamily: 'UhBee', fontSize: 25)),
    );
  }

  Widget _buildCategoryTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.black,
      indicatorColor: Colors.yellow,
      tabs: const [
        Tab(text: '연도'),
        Tab(text: '인물'),
        Tab(text: '좋아하는 기억'),
      ],
    );
  }

  Widget _buildGroupedMemoryCards() {
    return ListView.builder(
      itemCount: groupedNotes.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        String groupKey = groupedNotes.keys.elementAt(index);
        List<MemoryNoteModel>? groupNotes = groupedNotes[groupKey]; // 그룹화된 메모리 리스트
        MemoryNoteModel firstMemory = groupedNotes[groupKey]!.first;
        int groupNotesCnt = groupNotes?.length ?? 0; // 메모리 개수

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                groupKey, // 그룹 이름
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildMemoryCard(firstMemory, groupNotesCnt),
          ],
        );
      },
    );
  }

  // 개별 메모리 카드
  Widget _buildMemoryCard(MemoryNoteModel memory, int MemoryCnt) {
    return GestureDetector(
      onTap: () => Get.to(MemoryDetail(memory: memory)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.network(
                memory.img ?? '',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
              Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      memory.era.toString() + "년대" ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                      ),
                    ),
                    Text(
                      memory.imgTitle.toString()+" 외 "+MemoryCnt.toString()+"개" ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                      ),
                    ),
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
