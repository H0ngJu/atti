import 'package:atti/commons/AttiAppBar.dart';
import 'package:flutter/material.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AttiAppBar(
          title: Image.asset(
            'lib/assets/logo2.png',
            width: 150,
          ),
          showNotificationsIcon: true,
          showPersonIcon: true,
        ),
        body: Container(
            child: Text('Hello',
                style: TextStyle(fontSize: 24, color: Colors.white))));
  }
}
