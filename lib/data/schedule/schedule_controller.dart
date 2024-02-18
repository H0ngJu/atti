import 'package:get/get.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:atti/data/schedule/schedule_model.dart';
import '../auth_controller.dart';

class ScheduleController extends GetxController {
  final AuthController authController = Get.put(AuthController());
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
    schedule.value = ScheduleModel(
      patientId: authController.patientDocRef,
    );
  }

}
