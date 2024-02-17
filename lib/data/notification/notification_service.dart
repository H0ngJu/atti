import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() {
    return _instance;
  }
  NotificationService._();

  // 로컬 푸시 알림을 사용하기 위한 플러그인 인스턴스 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async { // 초기화 메서드
    // 알림에 사용할 로고
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = // 안드로이드 초기화 설정
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings); // 로컬 푸시 알림 초기화
  }

  // 푸시 알림 권한 요청
  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }

  // 푸시 알림 생성
  Future<void> showNotification() async {
    // 알림 채널 설정값 구성
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'counter_channel', // 알림 채널 ID
      'Counter Channel', // 알림 종류 설명
      channelDescription: 'This channel is used for counter-related notifications', // 알림 채널 설명
      importance: Importance.high, // 알림 중요도
    );

    // 알림 상세 정보 설정
    final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    
    await flutterLocalNotificationsPlugin.show( // 알림에 보이는 정보들
      0, // 알림 ID
      '테스트', // 알림 제목
      '알림 메시지', // 알림 메시지
      notificationDetails, // 알림 상세 정보
    );
  }

  // 매일 같은 시간에 알림 보내기 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  // Future<void> showDailyNotification(Time notificationTime) async {
  //   const int notificationId = 0;
  //
  //   final AndroidNotificationDetails androidNotificationDetails =
  //   AndroidNotificationDetails(
  //     'daily_channel',
  //     'Daily Notification Channel',
  //     channelDescription: 'This channel is used for daily notifications',
  //     importance: Importance.high,
  //   );
  //
  //   final NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidNotificationDetails);
  //
  //   // 현재 날짜와 시간을 기준으로 알림을 예약합니다.
  //   final now = DateTime.now();
  //   final scheduledDate = DateTime(now.year, now.month, now.day, notificationTime.hour, notificationTime.minute);
  //
  //   await flutterLocalNotificationsPlugin.showDailyAtTime(
  //     notificationId,
  //     '매일 알림',
  //     '매일 같은 시간에 보내는 알림입니다.',
  //     Time(notificationTime.hour, notificationTime.minute),
  //     notificationDetails,
  //   );
  // }

  makeDate(hour, min, sec){
    var now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
    if (when.isBefore(now)) {
      return when.add(Duration(days: 1));
    } else {
      return when;
    }
  }
  

}