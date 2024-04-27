import 'package:atti/data/schedule/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../auth_controller.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.put(AuthController());

  // 일정 등록 후 ScheduleModel 반환
  Future<ScheduleModel> addSchedule(ScheduleModel schedule) async {
    try {
      schedule.patientId = authController.patientDocRef;
      schedule.createdAt = Timestamp.now();
      DocumentReference docRef = await firestore.collection('schedule').add(schedule.toJson());
      schedule.reference = docRef;
      await docRef.update(schedule.toJson());
      return schedule; // 변경된 schedule 반환
    } catch (e) {
      print('Error adding schedule : $e');
      throw Future.error('Error adding schedule : $e'); // 예외 다시 throw
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

  Future<List<ScheduleModel>> getSchedulesInRange(DateTime startDate, DateTime endDate) async {
    try {
      // 입력된 시작 날짜와 종료 날짜의 시간을 조정
      DateTime startOfRange = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
      DateTime endOfRange = DateTime(endDate.year, endDate.month, endDate.day, 23, 59);

      QuerySnapshot querySnapshot = await firestore.collection('schedule')
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfRange))
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(endOfRange))
          .where('patientId', isEqualTo: authController.patientDocRef) // 사용자 연결 추가
          .get();

      List<ScheduleModel> schedules = [];
      for (var doc in querySnapshot.docs) {
        schedules.add(ScheduleModel.fromSnapShot(doc as DocumentSnapshot<Map<String, dynamic>>));
      }
      return schedules;
    } catch (e) {
      print('Error getting schedules in range: $e');
      return [];
    }
  }

}