import 'package:atti/data/report/viewsController.dart';
import 'package:atti/tmp/screen/memory/chat/Chat.dart';
import 'package:atti/tmp/screen/memory/gallery/GalleryOption.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/memory/memory_note_model.dart';
import '../chat/ChatHistory.dart';

class MemoryDetail extends StatelessWidget {
  final MemoryNoteModel memory;

  const MemoryDetail({Key? key, required this.memory}) : super(key: key);

  Widget MemoryDetailTitle() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${memory.era}년대',
            style: const TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
          ),
          Text(
            '\'${memory.imgTitle}\' 기억',
            style: const TextStyle(fontSize: 30, fontFamily: 'PretendardMedium'),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('기억 한 조각'),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 20, top: 10),
              child: TextButton(
                onPressed: () {
                  Get.to(const GalleryOption());
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape:
                      const CircleBorder(side: BorderSide(color: Color(0xffB3B3B3))),
                  minimumSize: const Size(48, 48),
                  elevation: 0,
                ),
                child: const Text(
                  '수정',
                  style: TextStyle(fontSize: 12, color: Color(0xff7E7E7E)),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        '${memory.img}',
                        fit: BoxFit.cover,
                        //width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MemoryDetailTitle(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  MemoryWords(memory: memory),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () => Get.to(ChatHistory(
                            memory: memory,
                          )),
                      child: Container(
                        height: 62,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: const Color(0xffF3F3F3),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '회상 대화 기록 보기',
                              style: TextStyle(
                                  fontFamily: 'PretendardRegular',
                                  fontSize: 24),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xffB8B8B8),
                            )
                          ],
                        ),
                      ))
                ]),
                //),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(Chat(memory: memory));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFFC215)),
                        child: const Text(
                          '회상 대화 시작하기',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        )))
              ],
            ),
          ),
        ));
  }
}

//기억 단어 보기 widget (stful)
class MemoryWords extends StatefulWidget {
  final MemoryNoteModel memory;

  const MemoryWords({Key? key, required this.memory}) : super(key: key);

  @override
  State<MemoryWords> createState() => _MemoryWordsState();
}

class _MemoryWordsState extends State<MemoryWords> {
  final _authentication = FirebaseAuth.instance;
  late ViewsController _viewsController;
  late DocumentReference memoryReferencePath;

  @override
  void initState() {
    super.initState();
    memoryReferencePath = widget.memory.reference!;
    _viewsController = ViewsController(
      memoryReferencePath,
    );
    _viewsController.addViews();
    tagList.addAll(widget.memory.keyword ?? []);
  }

  final List<String> tagList = [];

  Widget TagContainer(tag) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10), // 각 태그 사이의 간격을 조절합니다.
      decoration: BoxDecoration(
          color: const Color(0xffFFF5DB), borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 24, color: Color(0xffA38130)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //margin: EdgeInsets.only(top: 5, left: 10),
              child: const Text(
                '기억단어 보기',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'PretendardRegular'),
              ),
            ),
            SingleChildScrollView(
              child: Wrap(
                spacing: 10, // 각 행의 간격을 조절합니다.
                children: tagList.map((tag) {
                  return TagContainer(tag);
                }).toList(),
              ),
            ),
          ],
        ));
  }
}
