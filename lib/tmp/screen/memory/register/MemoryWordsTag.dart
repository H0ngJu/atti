import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class MemoryWordsTag extends StatelessWidget {
  final String name;

  MemoryWordsTag({required this.name});

  @override
  Widget build(BuildContext context) {
    ColorPallet _colorPallet = ColorPallet();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      //width: width * 0.29,
      //height: width * 0.12,
      margin: EdgeInsets.only(top: 6, bottom: 5, right: 5),
      padding: EdgeInsets.only(left: 15, right: 5),
      decoration: BoxDecoration(
        color: _colorPallet.lightYellow,
        border: Border.all(color: _colorPallet.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0, bottom: 3),
            child: Text(
              name,
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(width: 12),

          // 구분선
          Container(
            width: 1, // 구분선의 너비
            height: 50, // 부모 컨테이너의 높이에 맞춤
            color: _colorPallet.grey, // 구분선 색상
          ),

          SizedBox(width: 3),
          GestureDetector(
            onTap: () {
            },
            child: Icon(
              Icons.close,
              size: 27,
              color: Colors.black,
              weight: 100,
            ),
          ),
        ],
      ),
    );
  }
}