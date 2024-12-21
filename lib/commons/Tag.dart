import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final double fontsize;


  Tag({required this.name, this.backgroundColor = Colors.white, this.fontsize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: fontsize != 16 ? EdgeInsets.only(top: 12) : EdgeInsets.symmetric(vertical: 5),
      height: fontsize+14,
      padding: fontsize != 16 ? EdgeInsets.symmetric(horizontal: 10) : EdgeInsets.symmetric(horizontal: 5),
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
            style: TextStyle(fontSize: fontsize),
          ),
          SizedBox(width: fontsize != 16 ? 10 : 3),
          Container(
            height: fontsize+14,
            child: VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.black,
            ),
          ),
          SizedBox(width: fontsize != 16 ? 5 : 1,),
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
