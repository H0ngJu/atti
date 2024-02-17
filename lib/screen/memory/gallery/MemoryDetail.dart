import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/SimpleAppBar.dart';
import 'package:atti/screen/memory/chat/Chat.dart';
import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MemoryDetail extends StatelessWidget {
  const MemoryDetail({Key? key}) : super(key: key);

  Widget MemoryDetailTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '2010년대',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                '\'돌잔치\' 기억',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            ]),
        ElevatedButton(
          onPressed: () {
            Get.to(GalleryOption());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: CircleBorder(side: BorderSide(color: Color(0xffB3B3B3))),
            minimumSize: Size(48, 48),
            elevation: 0,
          ),
          child: Text(
            '수정',
            style: TextStyle(fontSize: 12, color: Color(0xff7E7E7E)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(title: '기억 한 조각'),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                /*Expanded(
              child:*/
                Column(children: [
                  MemoryDetailTitle(),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        'https://newsimg-hams.hankookilbo.com/2022/05/08/f5107e5a-7266-4132-9550-8713162df25a.jpg',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                  ),
                  MemoryWords(),
                ]),
                //),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    child: ElevatedButton(
                        onPressed: () {Get.to(Chat());},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFC215)),
                        child: Text(
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
  const MemoryWords({Key? key}) : super(key: key);

  @override
  State<MemoryWords> createState() => _MemoryWordsState();
}

class _MemoryWordsState extends State<MemoryWords> {
  final List<String> tagList = ['돌잔치', '손자', '2010', 'ddddd', 'ddddd'];
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Widget TagContainer(tag) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10), // 각 태그 사이의 간격을 조절합니다.
      decoration: BoxDecoration(
          color: Color(0xffFFF5DB), borderRadius: BorderRadius.circular(25)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Text(
        tag,
        style: TextStyle(fontSize: 24, color: Color(0xffA38130)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              '기억단어 보기',
              style: TextStyle(color: Color(0xffA38130), fontSize: 24),
            ),
          ),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Color(0xffFFC215), size: 50),
            onPressed: () {
              toggleExpand();
            },
          ),
        ),
        if (isExpanded)
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 10, // 각 행의 간격을 조절합니다.
                children: tagList.map((tag) {
                  return TagContainer(tag);
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
