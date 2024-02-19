import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

final AuthController authController = Get.put(AuthController());

class NotificationModel {
  String? uid; // 사용자의 UID
  String? title; // 카테고리
  String? message;
  Timestamp? time;
  DocumentReference? reference;
  bool? isPatient;

  NotificationModel({
    this.uid,
    this.title,
    this.message,
    this.time,
    this.reference,
    this.isPatient
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        title = json['title'],
        message = json['message'],
        reference = json['reference'],
        time = json['time'],
        isPatient = json['isPatient'];

  // Named constructor to create NotificationModel from DocumentSnapshot
  NotificationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : uid = snapshot.data()?['uid'],
        title = snapshot.data()?['title'],
        message = snapshot.data()?['message'],
        reference = snapshot.reference,
        time = snapshot.data()?['time'],
        isPatient = snapshot.data()?['isPatient'];

  // Named constructor to create NotificationModel from QueryDocumentSnapshot
  NotificationModel.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : uid = snapshot.data()['uid'],
        title = snapshot.data()['title'],
        message = snapshot.data()['message'],
        reference = snapshot.reference,
        time = snapshot.data()['time'],
        isPatient = snapshot.data()['isPatient'];

  // Convert NotificationModel to JSON format
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['title'] = title;
    map['message'] = message;
    map['reference'] = reference;
    map['time'] = time;
    map['isPatient'] = isPatient;
    return map;
  }
}
// 알림 데이터 저장하기
Future<void> addNotification(String title, String body, DateTime dateTime, bool isPatient) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('notification')
      .where('message', isEqualTo: body)
      .get();

  if (querySnapshot.docs.isEmpty) {
    NotificationModel notification = NotificationModel(
      uid: authController.loggedUser,
      title: title,
      message: body,
      time: Timestamp.fromDate(dateTime),
      isPatient: isPatient,
    );

    try {
      DocumentReference docRef = await FirebaseFirestore.instance.collection(
          'notification').add(notification.toJson());
      print('Notification saved to Firestore successfully!');

      notification.reference = docRef;
      await docRef.update({'reference': docRef});
    } catch (e) {
      print('Error saving notification to Firestore: $e');
    }
  }


// 알림 데이터 불러오기
  Future<List<NotificationModel>> getNotification() async {
    List<NotificationModel> notifications = [];

    try {
      DateTime now = DateTime.now();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('notification')
          .where('uid', isEqualTo: authController.loggedUser)
          .where('isPatient', isEqualTo: authController.isPatient)
          .get();

      querySnapshot.docs.forEach((doc) { // 현재 시간 이전의 알림만 선택
        NotificationModel notification = NotificationModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
        if (notification.time!.toDate().isBefore(now)) {
          notifications.add(notification);
        }
      });
      return notifications;
    } catch (e) {
      print('Error loading notifications from Firestore: $e');
      return [];
    }
  }
}