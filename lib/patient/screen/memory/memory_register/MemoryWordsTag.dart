import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class MemoryWordsTag extends StatelessWidget {
  final String name;

  MemoryWordsTag({required this.name});

  @override
  Widget build(BuildContext context) {
    ColorPallet _colorPallet = ColorPallet();

    return Container(
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: _colorPallet.lightYellow,
        border: Border.all(color: _colorPallet.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(width: 10),
          Container(
            height: 38,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: _colorPallet.grey,
            ),
          ),
          SizedBox(width: 3),
          GestureDetector(
            onTap: () {
            },
            child: Icon(
              Icons.close,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}