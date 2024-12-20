import 'package:atti/data/notification/notification_controller.dart';
import 'package:atti/data/report/viewsController.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/patient/screen/memory/ChatScreen.dart';
import 'package:atti/tmp/screen/memory/chat/Chat.dart';
import 'package:atti/tmp/screen/memory/chat/ChatHistory.dart';
import 'package:atti/tmp/screen/memory/gallery/GalleryOption.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../data/memory/memory_note_model.dart';

class MemoryInfo extends StatelessWidget {
  final MemoryNoteModel memory;

  const MemoryInfo({Key? key, required this.memory}) : super(key: key);

  Widget MemoryDetailTitle() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${memory.era}년대',
            style: TextStyle(fontSize: 24, fontFamily: 'PretendardRegular'),
          ),
          Text(
            '\'${memory.imgTitle}\' 기억',
            style: TextStyle(fontSize: 30, fontFamily: 'PretendardMedium'),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('기억 한 조각'),
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 20, top: 10),
                child: Icon(Icons.more_horiz))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Column(children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
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
                  SizedBox(
                    height: 10,
                  ),
                  MemoryDetailTitle(),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  FamilyWords(memory: memory),
                  SizedBox(
                    height: 10,
                  ),
                  MemoryWords(memory: memory),
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
                          Get.to(ChatScreen(memory: memory));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFC215)),
                        child: Text(
                          '아띠와 대화하기',
                          style: TextStyle(fontSize: 24, color: Colors.black),
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
      margin: EdgeInsets.only(top: 10, right: 10), // 각 태그 사이의 간격을 조절합니다.
      decoration: BoxDecoration(
          color: Color(0xffFFEFC6), borderRadius: BorderRadius.circular(25)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: TextStyle(fontSize: 24, color: Colors.black),
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
              child: Text(
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

//함께한 가족들
class FamilyWords extends StatefulWidget {
  final MemoryNoteModel memory;

  const FamilyWords({Key? key, required this.memory}) : super(key: key);

  @override
  State<FamilyWords> createState() => _FamilyWordsState();
}

class _FamilyWordsState extends State<FamilyWords> {
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
    tagList.addAll(widget.memory.selectedFamilyMember ?? []);
  }

  final List<String> tagList = [];

  Widget TagContainer(tag) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10), // 각 태그 사이의 간격을 조절합니다.
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(width: 0.7, color: Color(0xff868686))),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: TextStyle(fontSize: 24, color: Colors.black),
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
              child: Text(
                '함께한 사람',
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
