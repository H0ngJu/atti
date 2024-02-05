// 세부 기능 완료 화면
// 사용법 :
//
import 'package:flutter/material.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key, this.title, this.description, this.content});
  final title;
  final description;
  final content;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.0),
          Container(
            margin: EdgeInsets.only(left: 15, top: 100),
            child: Text(title, style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w500
            ),),
          ),

          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(description, style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600
            ),),
          ),
          SizedBox(height: 50.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(left: 15),
            child: Text(content, style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w600
            ),),
          ),
        ],
      ),
    );
  }
}
