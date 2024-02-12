import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:atti/data/schedule/schedule_model.dart';

class ScheduleController extends GetxController {
  final ScheduleService scheduleService = ScheduleService();
  var schedule = ScheduleModel().obs;
  var tmpScheduleName = ''.obs;

  void addSchedule() async {
    try {
      await scheduleService.addSchedule(schedule.value);
      clear();
    } catch (e) {
      print('Error adding schedule: $e');
    }
  }

  void clear() {
    schedule.value = ScheduleModel();
  }

}
