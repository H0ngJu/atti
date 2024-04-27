import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/notification/notification.dart';
import 'package:atti/screen/HomeCarer.dart';
import 'package:atti/screen/LogInSignUp/LogInScreen.dart';
import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen1.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen2.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen3.dart';
import 'package:atti/screen/LoginSignUp/IntroPage.dart';
import 'package:atti/screen/Notice/NoticeMain.dart';
import 'package:atti/screen/report/ReportDetail.dart';
import 'package:atti/screen/report/ReportHistory.dart';
import 'package:atti/screen/routine/RoutineMain.dart';
import 'package:atti/screen/routine/register/RoutineRegister1.dart';
import 'package:atti/screen/memory/chat/Chat.dart';
import 'package:atti/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/screen/memory/register/MemoryRegister1.dart';
import 'package:atti/screen/memory/register/MemoryRegister2.dart';
import 'package:atti/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:atti/screen/LoginSignUp/SignUpFamilyTag.dart';
import 'package:atti/screen/chatbot/Chatbot.dart';
import 'package:atti/screen/memory/gallery/MemoryDetail.dart';
import 'package:atti/screen/schedule/ScheduleMain.dart';
import 'package:atti/screen/memory/gallery/MainGallery.dart';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

void main() async {
  final notificationService = NotificationService();
  WidgetsFlutterBinding.ensureInitialized();
  //await notificationService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  await dotenv.load(fileName: '.env');
  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    notificationService.init(context);
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
      home: LogInScreen(),
    );
  }
}