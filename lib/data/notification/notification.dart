import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/notification/notification_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../routine/routine_model.dart';
import '../routine/routine_service.dart';
import '../schedule/schedule_model.dart';
import '../schedule/schedule_service.dart';
import 'package:get/get.dart';
import 'package:atti/main.dart';

// 로컬 푸시 알림을 사용하기 위한 플러그인 인스턴스 생성
//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  int id = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._();

  int createUniqueId() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    // 타임스탬프에 1씩 증가하는 값을 더합니다.
    id += 1;
    return timestamp + id;
  }

  // 푸시 알림 스트림 생성
  final StreamController<String?> streamController = StreamController<String?>.broadcast();

  Future<void> init(BuildContext context) async { // 초기화 메서드
    tz.initializeTimeZones();

    // 알림에 사용할 로고
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = // 안드로이드 초기화 설정
    InitializationSettings(
        android: initializationSettingsAndroid
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
        );
  }

  // 푸시 알림 권한 요청
  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
  Future<bool> requestBatteryPermissions() async {
    final status = await Permission.ignoreBatteryOptimizations.request().isGranted;
    return status;
  }

  // (환자, 보호자 공통) 매일 아침 7시에 알림 보내기 ======================================================
  Future<void> showDailyNotification() async {
    tz.initializeTimeZones();
    DateTime now = DateTime.now();
    DateTime dailyTime = DateTime(now.year, now.month, now.day, 7, 0);

    DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(authController.patientDocRef!.id)
        .get();
    String userName = userDocSnapshot['userName'];

    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'daily_channel',
      'Daily Notification Channel',
      channelDescription: 'This channel is used for daily notifications',
      importance: Importance.high,
      color: Color(0xffFFE9B3),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // createUniqueId(),
      '아띠',
      '오늘의 일과와 일정을 확인해보세요!',
      makeDate(7,0,0),
      NotificationDetails(android: androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'home'
    );

    await addNotification('매일 알림', '오늘 ${userName}님의 일과와 일정을 확인해보세요!', dailyTime, authController.isPatient);
  }

  // (보호자) 매주 월요일 아침에 알림 보내기 ======================================================
  Future<void> showWeeklyCarerNotification() async {
    tz.initializeTimeZones();

    DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(authController.patientDocRef!.id)
        .get();
    String userName = userDocSnapshot['userName'];

    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'weekly_channel',
      'Weekly Notification Channel',
      channelDescription: 'This channel is used for weekly notifications',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xffFFE9B3),
    );

    final now = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));
    final nextMonday = tz.TZDateTime(now.location, now.year, now.month, now.day + (8 - now.weekday) % 7, 7);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, //createUniqueId(),
      '아띠',
      '저번 주 ${userName}님의 보고서가 도착했어요!',
      nextMonday,
      NotificationDetails(android: androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'home',
    );

    await addNotification('주간 알림', '저번 주 ${userName}님의 보고서가 도착했어요!', nextMonday, false);
  }


  // 정해진 날짜, 시간에 예약 알림 보내기 =================================================================
  Future<void> showDateTimeNotification(int id, String title, String body, DateTime dateTime, String payload) async {
    tz.initializeTimeZones();
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.getLocation('Asia/Seoul'));

    print('showDateTimeNotification 함수 내부');

    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'This channel is used for scheduled notifications',
      importance: Importance.max,
      priority: Priority.high,
      //color: Color(0xffFFE9B3),
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
    );

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: 'full screen channel description',
            priority: Priority.high,
            importance: Importance.high,
            fullScreenIntent: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      print('알림 예약 성공');
    } catch (e) {
      print('알림 예약 실패: $e');
    }

    await addNotification(title, body, dateTime, authController.isPatient); // 알림 보낸 후 파이어베이스에 저장
  }

  // 일정 30분 전 알림 예약 =========================================================================
  Future<void> scheduleNotifications() async {
    List<ScheduleModel>? allSchedule = await ScheduleService().getAllSchedules();
    if (allSchedule != null) {
      for (ScheduleModel schedule in allSchedule) {
        DateTime notificationTime = schedule.time!.toDate().subtract(Duration(hours: 1));

        //현재 시간 이후의 알림에 대해서만 예약
        if (notificationTime.isAfter(DateTime.now())) {
          //notificationTime = DateTime.now().add(Duration(seconds: 10));
          await showDateTimeNotification(
              2,
              '일정 알림',
              '곧 \'${schedule.name}\'을(를) 하실 시간이에요!',
              notificationTime,
              '/schedule/${schedule.reference!.id}'
          );
        }
      }
    }
  }

  // 오늘의 루틴 시각에 알림 예약 =============================================================
  Future<void> routineNotifications() async {
    print("ㅡㅡㅡㅡㅡㅡㅡroutineNotificationsㅡㅡㅡㅡㅡㅡㅡ");
    RoutineService routineService = RoutineService();
    String today = DateFormat('E', 'ko-KR').format(DateTime.now());
    List<RoutineModel> routines = await routineService.getRoutinesByDay(today);

    DateTime now = DateTime.now();
    // 각 루틴에 대해 알림 예약
    for (RoutineModel routine in routines) {

      // if (routine.time != null && !routine.isFinished.contains(now.toString())) {
      if (routine.time != null) {
        final int hour = routine.time![0];
        final int minute = routine.time![1];

        //DateTime routineTime = DateTime(now.year, now.month, now.day, hour, minute);
        DateTime routineTime = makeDate(hour, minute, 0);

        //현재 시간 이후의 알림에 대해서만 예약
        if (routineTime.isAfter(now)) {
         //routineTime = now.add(Duration(seconds: 10));
          await showDateTimeNotification(
              3,
              '하루 일과 알림',
              '\'${routine.name}\' 일과를 완료하셨나요?',
              routineTime,
              '/routine/${routine.reference!.id}'
          );
          print("루틴 알림 예약 완료");
        }
      }
    }
  }

  // 루틴 등록할 때, 매주 정해진 요일과 시간에 알림 예약 =======================================
  Future<void> showWeeklyNotification(String name, List<int> daysOfWeek, int hour, int minute, DocumentReference docRef) async {
    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Seoul');

    final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'weekly_channel',
      'Weekly Notification Channel',
      channelDescription: 'This channel is used for weekly notifications',
      importance: Importance.high,
      color: Color(0xffFFE9B3),
    );

    for (int dayOfWeek in daysOfWeek) {
      final scheduledTime = makeWeeklyDate(dayOfWeek, hour, minute, location);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        dayOfWeek, // Unique ID for each notification
        '일과 알림',
        '\'${name}\' 일과를 완료하셨나요?',
        scheduledTime,
        NotificationDetails(android: androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: '/routine/$docRef',
      );

      await addNotification(
        '일과 알림',
        '\'${name}\' 일과를 완료하셨나요?',
        scheduledTime,
        authController.isPatient,
      );
    }
  }

  tz.TZDateTime makeWeeklyDate(int dayOfWeek, int hour, int minute, tz.Location location) {
    final now = tz.TZDateTime.now(location);
    tz.TZDateTime scheduledDate = tz.TZDateTime(location, now.year, now.month, now.day, hour, minute);

    while (scheduledDate.weekday != dayOfWeek) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    // Ensure the scheduled time is in the future
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 7));
    }

    return scheduledDate;
  }


  makeDate(hour, min, sec){  // tz로 날짜, 시간 변환
    var now = tz.TZDateTime.now(tz.getLocation('Asia/Seoul'));
    var when = tz.TZDateTime(tz.getLocation('Asia/Seoul'), now.year, now.month, now.day, hour, min, sec);
    if (when.isBefore(now)) {
      return when.add(Duration(seconds: 10));
    } else {
      return when;
    }
  }

  // Foreground & Background 상태에서 실행되는 메소드 (앱이 열린 상태에서 받은 경우)
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null || notificationResponse.payload!.isNotEmpty) {
      print('------------ FOREGROUND PAYLOAD: ${notificationResponse.payload} ------------');
      streamController.add(notificationResponse.payload); // Payload(전송 데이터)를 Stream에 추가합니다.
    }
  }

  // // // Terminate 상태에서 실행되는 메소드 (앱이 닫힌 상태에서 받은 경우)
  // @pragma('vm:entry-point')
  // void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
  //   final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //   await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //   // 앱이 Notification을 통해서 열린 경우라면 Payload(전송 데이터)를 Stream에 추가합니다.
  //   if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //     String payload = notificationAppLaunchDetails!.notificationResponse?.payload ?? "";
  //     print("-----------BACKGROUND PAYLOAD: $payload-----------");
  //     streamController.add(payload);
  //   }
  // }

// FCM 메시지로부터 로컬 알림 표시
  Future<void> showFCMNotification(RemoteMessage message) async {
    final title = message.notification!.title;
    final body = message.notification!.body;

    // 로컬 알림 설정
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // 채널 ID
      'your_channel_name', // 채널 이름
      channelDescription: 'your_channel_description', // 채널 설명
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // 로컬 알림 표시
    await flutterLocalNotificationsPlugin.show(
      4, // 고유 ID
      title, // 제목
      body, // 내용
      platformChannelSpecifics,
      //payload: 'item x',
    );
  }

}
