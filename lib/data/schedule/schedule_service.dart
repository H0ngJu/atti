import 'package:atti/data/schedule/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../auth_controller.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.put(AuthController());

  // 일정 등록
  Future<void> addSchedule(ScheduleModel schedule) async {
    try {
      schedule.patientId = authController.patientDocRef;
      schedule.createdAt = Timestamp.now();
      DocumentReference docRef = await firestore.collection('schedule').add(schedule.toJson());
      schedule.reference = docRef;
      await docRef.update(schedule.toJson());
    } catch (e) {
      print('Error adding schedule : $e');
    }
  }

  // 특정 날짜의 일정 가져오기
  Future<List<ScheduleModel>> getSchedulesByDate(DateTime date) async {
    try {
      // 입력된 날짜의 시간과 분을 0으로 설정
      DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0);
      DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59);

      QuerySnapshot querySnapshot = await firestore.collection('schedule')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .where('patientId', isEqualTo: authController.patientDocRef) // 사용자 연결 추가
          .get();

      List<ScheduleModel> schedules = [];
      querySnapshot.docs.forEach((doc) {
        schedules.add(ScheduleModel.fromSnapShot(doc as DocumentSnapshot<Map<String, dynamic>>));
      });
      return schedules;
    } catch (e) {
      print('Error getting schedules: $e');
      return [];
    }
  }

  // 일정 완료
  Future<void> completeSchedule(DocumentReference docRef) async {
    try {
      await docRef.update({
        'isFinished': true,
      });
    } catch (e) {
      print('Error completing schedule: $e');
    }
  }

  // 모든 일정 가져오기
  Future<List<ScheduleModel>> getAllSchedules() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('schedule')
          .where('patientId', isEqualTo: authController.patientDocRef) // 사용자 연결 추가
          .get();

      List<ScheduleModel> schedules = [];
      querySnapshot.docs.forEach((doc) {
        schedules.add(ScheduleModel.fromSnapShot(doc as DocumentSnapshot<Map<String, dynamic>>));
      });
      return schedules;
    } catch (e) {
      print('Error getting all schedules: $e');
      return [];
    }
  }


}