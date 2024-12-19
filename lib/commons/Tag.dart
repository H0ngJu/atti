import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String name;
  final Color backgroundColor;

  Tag({required this.name, this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 3),
          Container(
            height: 40,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 1),
          GestureDetector(
            onTap: () {
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
