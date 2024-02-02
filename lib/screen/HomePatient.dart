import 'package:flutter/material.dart';

class HomePatient extends StatelessWidget {
  const HomePatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset('lib/assets/logo.png', fit: BoxFit.cover),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ))
          ],
        ),
        body: Container(
            child: Text('Hello',
                style: TextStyle(fontSize: 24, color: Colors.white))));
  }
}
