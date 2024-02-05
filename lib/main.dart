import 'package:atti/screen/HomePatient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/screen/schedule/ScheduleRegister1.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'), // Korean
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const ScheduleRegister1(),
    );
  }
}