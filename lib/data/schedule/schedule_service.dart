import 'package:atti/data/schedule/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ScheduleService {
  final firestore = FirebaseFirestore.instance;

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


}