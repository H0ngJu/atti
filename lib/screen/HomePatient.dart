// 홈 화면
import 'package:flutter/material.dart';


class HomePatient extends StatelessWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Container(child: Text(
      'Hello',
      style: TextStyle(
        fontSize: 24,
        color: Colors.white)))
    );
  }
}