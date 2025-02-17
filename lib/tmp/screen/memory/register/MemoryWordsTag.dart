import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class MemoryWordsTag extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const MemoryWordsTag({super.key, 
    required this.name,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    ColorPallet colorPallet = ColorPallet();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      //width: width * 0.29,
      //height: width * 0.12,
      margin: const EdgeInsets.only(top: 6, bottom: 5, right: 5),
      padding: const EdgeInsets.only(left: 15, right: 5),
      decoration: BoxDecoration(
        color: colorPallet.lightYellow,
        border: Border.all(
            color: colorPallet.grey,
            width: 0.7
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 0, bottom: 3),
            child: Text(
              name,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 12),

          // 구분선
          Container(
            width: 0.5, // 구분선의 너비
            height: 50, // 부모 컨테이너의 높이에 맞춤
            color: colorPallet.grey, // 구분선 색상
          ),

          const SizedBox(width: 3),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
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