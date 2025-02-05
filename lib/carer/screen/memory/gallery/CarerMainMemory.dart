import 'package:atti/commons/AttiSpeechBubble.dart';
import 'package:atti/data/memory/RecollectionData.dart';
import 'package:atti/patient/screen/memory/gallery/MemoryAlbum.dart';
import 'package:atti/tmp/screen/memory/gallery/RecollectionDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/data/memory/memory_note_service.dart';
import 'package:atti/patient/screen/memory/gallery/AddButton.dart';
import 'package:atti/commons/AttiBottomNavi.dart';
import 'dart:math';
import '../../../../commons/colorPallet.dart';

class CarerMainMemory extends StatefulWidget {
  const CarerMainMemory({Key? key}) : super(key: key);

  @override
  State<CarerMainMemory> createState() => _MainGalleryState();
}

class _MainGalleryState extends State<CarerMainMemory>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final MemoryNoteService memoryNoteService = MemoryNoteService();
  final FlutterTts flutterTts = FlutterTts();
  late RecollectionData _randomData;
  final ColorPallet colorPallet = Get.put(ColorPallet());

  Map<String, List<MemoryNoteModel>> groupedNotes = {};
  bool isLoading = true;
  int _selectedIndex = 0;
  int _selectedCategory = 0;
  final List<String> categories = ["연도", "인물", "좋아하는 기억"];
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _randomData = dummyData[Random().nextInt(dummyData.length)];
    fetchData();
    _speak();
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage('ko-KR');
    await flutterTts.setPitch(1);
    await flutterTts.speak("사진을 눌러 그 기억에 대해 이야기해요");
  }

  Future<void> fetchData() async {
    if (_selectedCategory == 2) {
      fetchFavoriteMemories().then((favoriteMemories) {
        if (mounted) {
          setState(() {
            groupedNotes = favoriteMemories;
            isLoading = false;
          });
        }
      });
    } else {
      List<MemoryNoteModel> fetchedNotes =
          await memoryNoteService.getMemoryNote();
      _groupNotes(fetchedNotes);
    }
  }

  Future<Map<String, List<MemoryNoteModel>>> fetchFavoriteMemories() async {
    final Map<String, List<MemoryNoteModel>> groupedMemories = {};
    final Map<DocumentReference, int> totalViews = {};

    try {
      final QuerySnapshot<Map<String, dynamic>> viewsSnapshot =
          await FirebaseFirestore.instance.collection('views').get();

      for (var doc in viewsSnapshot.docs) {
        final data = doc.data();

        // 총 조회수 구하기
        // memoryViews의 키를 DocumentReference로 변환하고 조회수 합산
        if (data['memoryViews'] != null) {
          (data['memoryViews'] as Map<String, dynamic>).forEach((key, value) {
            final memoryRef = FirebaseFirestore.instance.doc(key);
            final views = value as int;

            // 기존 조회수에 누적
            totalViews[memoryRef] = (totalViews[memoryRef] ?? 0) + views;
          });
        }
      }

      // 총 조회수를 기준으로 그룹화
      for (var entry in totalViews.entries) {
        final memoryRef = entry.key;
        final totalViewCount = entry.value;

        // 데이터가 안모여 있어서 일단 조회수 10회 기준으로 설정
        if (totalViewCount >= 10) {
          int rangeStart = (totalViewCount ~/ 10) * 10;
          int rangeEnd = rangeStart + 9;
          String groupKey = "$rangeStart번 이상 조회";

          DocumentSnapshot<Map<String, dynamic>> memoryDoc =
              await memoryRef.get() as DocumentSnapshot<Map<String, dynamic>>;

          if (memoryDoc.exists) {
            MemoryNoteModel memory = MemoryNoteModel.fromSnapShot(memoryDoc);
            groupedMemories.putIfAbsent(groupKey, () => []).add(memory);
          }
        }
      }

      // key로 정렬
      final sortedKeys = groupedMemories.keys.toList()
        ..sort((a, b) {
          int rangeStartA = int.parse(a.split('번').first);
          int rangeStartB = int.parse(b.split('번').first);
          return rangeStartB.compareTo(rangeStartA);
        });
      final sortedGroupedMemories =
          Map<String, List<MemoryNoteModel>>.fromEntries(
        sortedKeys.map((key) => MapEntry(key, groupedMemories[key]!)),
      );

      // 출력 결과 확인
      print("좋아하는 기억 데이터:");
      sortedGroupedMemories.forEach((key, value) {
        print('$key:');
        value.forEach((memory) {
          print(memory); // MemoryNoteModel의 toString 메서드 호출
        });
      });
      return sortedGroupedMemories;
    } catch (e) {
      print('ERROR');
      return {};
    }
  }

  Future<void> _groupNotes(List<MemoryNoteModel> notes) async {
    setState(() {
      isLoading = true;
    });

    if (_selectedCategory == 0) {
      // 연도 기준으로 그룹화
      groupedNotes = groupBy(
        notes,
        (memory) => memory.era?.toString() ?? '기타', // era 데이터가 없는 경우 '기타' 처리
      );

      // 키를 연도로 변환 후 내림차순 정렬
      groupedNotes = Map.fromEntries(
        groupedNotes.entries.toList()
          ..sort((a, b) {
            // '기타'는 마지막에 배치
            if (a.key == '기타') return 1;
            if (b.key == '기타') return -1;

            return int.parse(b.key).compareTo(int.parse(a.key));
          }),
      );
    } else if (_selectedCategory == 1) {
      // 인물 기준으로 그룹화
      groupedNotes = {};
      for (var memory in notes) {
        for (var member in memory.selectedFamilyMember ?? []) {
          groupedNotes.putIfAbsent(member, () => []).add(memory);
        }
      }

      // 인물 이름 기준으로 정렬
      groupedNotes = Map.fromEntries(
        groupedNotes.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );

      for (var memory in notes) {
        print("Memory selectedFamilyMember: ${memory.selectedFamilyMember}");
      }

      print("인물 카테고리 데이터:");
      groupedNotes.forEach((key, value) {
        print("$key: ${value.length} items");
      });
    } else {
      // 좋아하는 기억 그룹화
      groupedNotes = await fetchFavoriteMemories();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              SingleChildScrollView(
                  //padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                children: [
                  SizedBox(
                    height: height * 0.06,
                  ),
                  _buildHeader(),
                  SizedBox(height: 20),
                  _buildImageSection(),
                  SizedBox(height: 20),
                  Container(
                    width: width * 0.9,
                    child: AttiSpeechBubble(
                        comment: '사진을 눌러\n그 기억에 대해 이야기해요',
                        color: colorPallet.lightYellow),
                  ),
                  SizedBox(height: 10),
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Container(
            //margin: EdgeInsets.only(top: 20),
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: authController.isPatient
                          ? '${authController.userName.value}님의\n'
                          : '${authController.patientName.value}님의\n',
                      style: TextStyle(fontSize: 24, height: 1.2),
                    ),
                    TextSpan(
                      text: isEditMode ? '내 기억 편집 모드' : '소중한 기억을 모아봤어요',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isEditMode = !isEditMode; // 상태 토글
                });
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: isEditMode ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1)),
                child: Icon(
                  isEditMode ? Icons.close : Icons.edit,
                  color: isEditMode ? Colors.black : Colors.white,
                  size: 22,
                ),
              ),
            )
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
            width: MediaQuery.of(context).size.width * 0.57),
      ],
    );
  }

  // Widget _buildSpeechBubble() {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //         color: Color(0xffFFEFC6),
  //         borderRadius: BorderRadius.all(Radius.circular(15))),
  //     child: Text('사진을 눌러\n그 기억에 대해 이야기해요',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //             color: Colors.black, fontFamily: 'UhBee', fontSize: 25)),
  //   );
  // }

  Widget _buildCategoryTabs() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
        children: categories.map((category) {
          int index = categories.indexOf(category);
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
                fetchData(); // 선택 변경 시 데이터 다시 로드
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 20), // 카테고리 간격
              padding: EdgeInsets.only(top: 10),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: _selectedCategory == index
                      ? FontWeight.bold
                      : FontWeight.normal, // 선택된 카테고리는 bold
                  color:
                      _selectedCategory == index ? Colors.black : Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroupedMemoryCards() {
    if (_selectedCategory == 0) {
      // 연도를 클릭한 경우
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListView.builder(
          itemCount: groupedNotes.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              // 첫 번째 Row는 _randomData와 groupedNotes의 첫 번째 아이템을 가로로 배치
              String firstGroupKey = groupedNotes.keys.first; // 첫 번째 그룹 키 가져오기
              MemoryNoteModel firstMemory =
                  groupedNotes[firstGroupKey]!.first; // 첫 번째 메모리 아이템

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildRecollectionCard(_randomData),
                  ),
                  Expanded(
                    child: _buildMemoryCard(
                        firstMemory, groupedNotes[firstGroupKey]!.length - 1),
                  ),
                ],
              );
            }

            String groupKey = groupedNotes.keys.elementAt(index);
            List<MemoryNoteModel>? groupNotes = groupedNotes[groupKey];
            MemoryNoteModel firstMemory = groupNotes!.first;
            int groupNotesCnt = groupNotes.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMemoryCard(firstMemory, groupNotesCnt - 1),
              ],
            );
          },
        ),
      );
    } else {
      // 좋아하는 기억 또는 인물을 클릭한 경우
      return ListView.builder(
        itemCount: groupedNotes.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          String groupKey = groupedNotes.keys.elementAt(index);
          List<MemoryNoteModel>? groupNotes = groupedNotes[groupKey];
          MemoryNoteModel firstMemory = groupNotes!.first;
          int groupNotesCnt = groupNotes.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFavoriteMemoryCard(
                  firstMemory, groupNotesCnt - 1, groupKey),
            ],
          );
        },
      );
    }
  }

  // 그 때 그시절
  Widget _buildRecollectionCard(RecollectionData recollection) {
    return GestureDetector(
      onTap: () => Get.to(RecollectionDetail(data: recollection)),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey.withOpacity(0.2),
          //       spreadRadius: 1,
          //       blurRadius: 5)
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Image.network(
                recollection.img ?? '',
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
                          "그때 그 시절",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 5)
                            ],
                          ),
                        ),
                        Text(
                          recollection.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 5)
                            ],
                          ),
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }

  // 연도 메모리 카드
  Widget _buildMemoryCard(MemoryNoteModel memory, int MemoryCnt) {
    String groupKey = groupedNotes.entries
        .firstWhere((entry) => entry.value.contains(memory))
        .key;
    List<MemoryNoteModel> group = groupedNotes[groupKey]!; // 앨범 목록 전달

    return GestureDetector(
      onTap: () => Get.to(MemoryAlbum(
        memoryKey: groupKey,
        group: group,
        isEditMode: isEditMode,
      )),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey.withOpacity(0.2),
          //       spreadRadius: 1,
          //       blurRadius: 5)
          // ],
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
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 5)
                            ],
                          ),
                        ),
                        Text(
                          MemoryCnt == 0
                              ? memory.imgTitle.toString()
                              : memory.imgTitle.toString() +
                                      " 외 " +
                                      MemoryCnt.toString() +
                                      "개" ??
                                  '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 5)
                            ],
                          ),
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }

  // 좋아하는 기억 메모리 카드
  Widget _buildFavoriteMemoryCard(
      MemoryNoteModel memory, int MemoryCnt, String groupKey) {
    List<MemoryNoteModel> group = groupedNotes[groupKey]!;

    return GestureDetector(
      onTap: () => Get.to(MemoryAlbum(
        memoryKey: groupKey,
        group: group,
        isEditMode: isEditMode,
      )),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.grey.withOpacity(0.2),
          //       spreadRadius: 1,
          //       blurRadius: 5)
          // ],
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
                          "${groupKey}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 5)
                            ],
                          ),
                        ),
                        Text(
                          MemoryCnt == 0
                              ? memory.imgTitle.toString()
                              : memory.imgTitle.toString() +
                                      " 외 " +
                                      MemoryCnt.toString() +
                                      "개" ??
                                  '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 5)
                            ],
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
