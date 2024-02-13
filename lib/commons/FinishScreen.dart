// 세부 기능 완료 화면
// 사용법 :
// FinishScreen(title: '일정 등록하기', description: '손주 생일', content: '일정을 성공적으로 등록했어요!',)
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key, this.content,});
  // final title;
  // final description;
  final content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(left: 15),
          child: Text(content, style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.w600, color: Color(0xffA38130)
          ),),
        ),
      ],
    );
  }
}
