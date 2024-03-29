import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/notification/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../screen/routine/RoutineMain.dart';
import '../../screen/schedule/ScheduleMain.dart';
import '../routine/routine_model.dart';
import '../routine/routine_service.dart';
import '../schedule/schedule_model.dart';
import '../schedule/schedule_service.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._();

  // 로컬 푸시 알림을 사용하기 위한 플러그인 인스턴스 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

        // 푸시알림 핸들링
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          if (response.payload == 'schedule') {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return ScheduleMain();
            }));
          } else if (response.payload == 'routine') {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return RoutineMain();
            }));
          }
        }); // 로컬 푸시 알림 초기화
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

  // (환자, 보호자 공통) 매일 아침 7시에 알림 보내기 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  Future<void> showDailyNotification() async {
    tz.initializeTimeZones();
    DateTime now = DateTime.now();
    DateTime dailyTime = DateTime(now.year, now.month, now.day, 7, 0);

    DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(authController.patientDocRef.id)
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
      0,
      '아띠',
      '오늘의 일과와 일정을 확인해보세요!',
      makeDate(7,0,0),
      NotificationDetails(android: androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await addNotification('매일 알림', '오늘 ${userName}님의 일과와 일정을 확인해보세요!', dailyTime, authController.isPatient);
  }

  // (보호자) 매주 월요일 아침에 알림 보내기 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  Future<void> showWeeklyCarerNotification() async {
    tz.initializeTimeZones();

    DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(authController.patientDocRef.id)
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

    final now = tz.TZDateTime.now(tz.local);
    final nextMonday = tz.TZDateTime(now.location, now.year, now.month, now.day + (8 - now.weekday) % 7, 7);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '아띠',
      '저번 주 ${userName}님의 보고서가 도착했어요!',
      nextMonday,
      NotificationDetails(android: androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'weekly_notification',
    );

    await addNotification('주간 알림', '저번 주 ${userName}님의 보고서가 도착했어요!', nextMonday, false);
  }


  // 정해진 날짜, 시간에 예약 알림 보내기 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  Future<void> showDateTimeNotification(String title, String body, DateTime dateTime, String payload) async {
    tz.initializeTimeZones();
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notification Channel',
      channelDescription: 'This channel is used for scheduled notifications',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xffFFE9B3),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      NotificationDetails(android: androidNotificationDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload
    );

    await addNotification(title, body, dateTime, authController.isPatient); // 알림 보낸 후 파이어베이스에 저장
  }

  // 일정 30분 전 알림 예약
  Future<void> scheduleNotifications() async {
    List<ScheduleModel>? allSchedule = await ScheduleService().getAllSchedules();
    if (allSchedule != null) {
      allSchedule.forEach((schedule) async {
        DateTime notificationTime = schedule.time!.toDate().subtract(Duration(minutes: 30));

        // 만약 알림 시간이 현재 시간 이전이라면 1분 뒤로 설정
        // if (notificationTime.isBefore(DateTime.now())) {
        //   notificationTime = DateTime.now().add(Duration(minutes: 1));
        // }

        await showDateTimeNotification(
          '일정 알림',
          '곧 \'${schedule.name}\'을(를) 하실 시간이에요!',
          notificationTime,
          'schedule'
        );
      });
    }
  }

  // 오늘의 루틴 시각에 알림 예약
  Future<void> routineNotifications() async {
    RoutineService routineService = RoutineService();
    String today = DateFormat('E', 'ko-KR').format(DateTime.now());
    List<RoutineModel> routines = await routineService.getRoutinesByDay(today);

    DateTime now = DateTime.now();
    // 각 루틴에 대해 알림 예약
    routines.forEach((routine) async {
      // if (routine.time != null && !routine.isFinished.contains(now.toString())) {
      if (routine.time != null) {
        final int hour = routine.time![0];
        final int minute = routine.time![1];

        DateTime routineTime = DateTime(now.year, now.month, now.day, hour, minute);

        // 만약 루틴 시간이 현재 시간 이전이라면 1분 뒤로 설정
        // if (routineTime.isBefore(now)) {
        //   routineTime = now.add(Duration(minutes: 1));
        // }

        await NotificationService().showDateTimeNotification(
          '하루 일과 알림',
          '\'${routine.name}\' 일과를 완료하셨나요?',
          routineTime,
          'routine'
        );
      }
    });
  }



  makeDate(hour, min, sec){  // tz로 날짜, 시간 변환
    var now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
    if (when.isBefore(now)) {
      return when.add(Duration(days: 1));
    } else {
      return when;
    }
  }
}
