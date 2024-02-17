import 'package:atti/screen/HomeCarer.dart';
import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:atti/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:atti/screen/LoginSignUp/SignUpFamilyTag.dart';
import 'package:atti/screen/chatbot/Chatbot.dart';
import 'package:atti/screen/chatbot/reportTest.dart';
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
import 'package:atti/screen/HomePatient.dart';
import 'package:atti/screen/schedule/finish/ScheduleFinish1.dart';
import 'package:atti/screen/schedule/register/ScheduleRegister1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
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
      home: MemoryDetail(),
    );
  }
}