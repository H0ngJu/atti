import 'package:atti/screen/HomePatient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/screen/schedule/schedule.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const ScheduleRegister1(),
    );
  }
}