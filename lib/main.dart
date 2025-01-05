import 'dart:ffi';

import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/notification/notification.dart';
import 'package:atti/tmp/screen/HomePatient.dart';
import 'package:atti/tmp/screen/LogInSignUp/LogInScreen.dart';
import 'package:atti/tmp/screen/LogInSignUp/LogInSignUpMainScreen.dart';

import 'package:atti/tmp/screen/LogInSignUp/SignUpScreen1.dart';
import 'package:atti/tmp/screen/LogInSignUp/SignUpScreen2.dart';
import 'package:atti/tmp/screen/LogInSignUp/SignUpScreen3.dart';
import 'package:atti/tmp/screen/LoginSignUp/IntroPage.dart';
import 'package:atti/tmp/screen/Notice/NoticeMain.dart';
import 'package:atti/tmp/screen/report/ReportHistory.dart';
import 'package:atti/tmp/screen/routine/RoutineMain.dart';
import 'package:atti/tmp/screen/routine/register/RoutineRegister1.dart';
import 'package:atti/tmp/screen/memory/chat/Chat.dart';
import 'package:atti/tmp/screen/memory/gallery/GalleryOption.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister2.dart';
import 'package:atti/tmp/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:atti/tmp/screen/LoginSignUp/SignUpFamilyTag.dart';
import 'package:atti/tmp/screen/chatbot/Chatbot.dart';
import 'package:atti/tmp/screen/memory/gallery/MemoryDetail.dart';
import 'package:atti/tmp/screen/schedule/ScheduleMain.dart';
import 'package:atti/tmp/screen/memory/gallery/MainGallery.dart';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// terminate 상태에서 알림을 탭하는 경우 처리
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  await Firebase.initializeApp();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // 앱이 Notification을 통해서 열린 경우라면 Payload(전송 데이터)를 Stream에 추가합니다.
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    String payload = notificationAppLaunchDetails!.notificationResponse?.payload ?? "";
    print("-----------BACKGROUND PAYLOAD: $payload-----------");
    //streamController.add(payload);
  }
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService().showFCMNotification(message);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await notificationService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //NotificationService().onDidReceiveBackgroundNotificationResponse;

  await FirebaseAppCheck.instance.activate(
    // webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  await dotenv.load(fileName: '.env');

  final notificationService = NotificationService();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  // FCM 메시지 수신 핸들러 등록
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notificationService.showFCMNotification(message);
  });

  String initialRoute = '/';
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final String payload = notificationAppLaunchDetails!.notificationResponse?.payload ?? "";
    if (payload == 'schedule') {
      initialRoute = '/schedule';
    } else if (payload == 'routine') {
      initialRoute = '/routine';
    }
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp(notificationService: notificationService, initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  final String initialRoute;
  MyApp({super.key, required this.notificationService, required this.initialRoute});

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
      initialRoute: initialRoute,

      // 앱 전체 글자 크기 고정하기 !!
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0), // 글자 크기를 고정
          ),
          child: child!,
        );
      },

      routes: {
        '/': (context) => IntroPage(),
        '/schedule': (context) => ScheduleMain(),
        '/routine': (context) => RoutineMain(),
      },
    );
  }
}