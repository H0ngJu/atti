import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class MemoryWordsTag extends StatelessWidget {
  final String name;

  const MemoryWordsTag({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    ColorPallet colorPallet = ColorPallet();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(left: 10, right: 5),
      decoration: BoxDecoration(
        color: colorPallet.lightYellow,
        border: Border.all(color: colorPallet.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 38,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: colorPallet.grey,
            ),
          ),
          const SizedBox(width: 3),
          GestureDetector(
            onTap: () {
            },
            child: const Icon(
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