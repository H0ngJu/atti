import 'package:atti/data/schedule/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;

  // 일정 등록
  Future<void> addSchedule(ScheduleModel schedule) async {
    try {
      schedule.createdAt = Timestamp.now();
      DocumentReference docRef = await firestore.collection('schedule').add(schedule.toJson());
      schedule.reference = docRef;
      await docRef.update(schedule.toJson());
    } catch (e) {
      print('Error adding task: $e');
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


}