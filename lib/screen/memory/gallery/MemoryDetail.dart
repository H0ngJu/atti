import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MemoryDetail extends StatelessWidget {
  const MemoryDetail({Key? key}) : super(key: key);

  Widget MemoryDetailTitle(){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children : [
        Text('2010년대', style: TextStyle(fontSize: 24),),
        Text('\'돌잔치\' 기억', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)]),
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
      appBar: AppBar(
        title: Text('기억 한 조각'),
        leading: Icon(Icons.arrow_back_rounded),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            MemoryDetailTitle(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child : ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                'https://newsimg-hams.hankookilbo.com/2022/05/08/f5107e5a-7266-4132-9550-8713162df25a.jpg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width*0.9,
                height: MediaQuery.of(context).size.height*0.4,
              ),
            ),
            ),
            MemoryWords(),
          ],
        ),
      ),
    );
  }
}

//기억 단어 보기 widget (stful)
class MemoryWords extends StatefulWidget {
  const MemoryWords({Key? key}) : super(key: key);

  @override
  State<MemoryWords> createState() => _MemoryWordsState();
}

class _MemoryWordsState extends State<MemoryWords> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text('기억단어 보기'),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              toggleExpand();
            },
          ),
        ),
        if (isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('손자'),
                // Add more tags here
              ],
            ),
          ),
      ],
    );
  }
}
