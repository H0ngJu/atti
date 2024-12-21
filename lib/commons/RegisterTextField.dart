import 'package:atti/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import 'colorPallet.dart';
final ColorPallet colorPallet = Get.put(ColorPallet());

class RegisterTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  const RegisterTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 24,
            color: colorPallet.khaki, // khaki 색상
            fontWeight: FontWeight.w400
          ),
          filled: true, // 배경을 채움
          fillColor: Color(0xffFFF5DB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(15), // 위아래 여백 조절
        ),
      ),
    );
  }
}
