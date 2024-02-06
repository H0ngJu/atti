import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 일정 등록 컨트롤러
class ScheduleController extends GetxController {
  var name = ''.obs;
  var date = ''.obs;
  var time = ''.obs;
  var location = ''.obs;
  var memo = ''.obs;
}

void addScheduleToFirestore(ScheduleController scheduleController) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance; // Firestore 인스턴스

  try {
    DateTime now = DateTime.now(); // 현재 날짜와 시간

    Map<String, dynamic> scheduleData = {
      "createdAt": now,
      "isFinished": false,
      "memo": scheduleController.memo.value,
      "name": scheduleController.name.value,
      "patientId": "",
      "location": scheduleController.location.value,
      "time": scheduleController.time.value,
      "date": scheduleController.date.value,
    };

    await firestore.collection('schedule').add(scheduleData); // 데이터 추가

    print('Schedule data saved to Firestore successfully!');
  } catch (error) {
    print('Failed to save schedule data to Firestore: $error');
  }
}