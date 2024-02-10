import 'package:atti/commons/AttiAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryOption extends StatefulWidget {
  const GalleryOption({Key? key}) : super(key: key);

  @override
  State<GalleryOption> createState() => _GalleryOptionState();
}

class _GalleryOptionState extends State<GalleryOption> {
  Widget CurrentTag() {
    return Column(
      children: [
        Container(
          child: Text(
            '현재 단어',
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }

  Widget OldTag() {
    return Column(
      children: [
        Container(
          child: Text(
            '변경할 단어',
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기억 순서 변경'),
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
      ),
      body: Column(
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
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                    text: '사진을 다시 나열할까요?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
            child: OldTag(),
          ),
          Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFFC215),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.9, 48),
                  ),
                  child: Text(
                    '사진 나열하기',
                    style: TextStyle(color: Colors.white),
                  ))),
        ],
      ),
    );
  }
}
