import 'package:get/get.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:atti/data/schedule/schedule_model.dart';
import '../auth_controller.dart';

class ScheduleController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final ScheduleService scheduleService = ScheduleService();
  var schedule = ScheduleModel().obs;
  var tmpScheduleName = ''.obs;

  Future<ScheduleModel> addSchedule() async { // Future<ScheduleModel> 반환 타입으로 변경
    try {
      final addedSchedule = await scheduleService.addSchedule(schedule.value);
      clear();
      return addedSchedule; // 추가된 ScheduleModel 반환
    } catch (e) {
      print('Error adding schedule: $e');
      throw Future.error('Error adding schedule: $e'); // 예외 다시 throw
    }
  }

  void clear() {
    schedule.value = ScheduleModel(
      patientId: authController.patientDocRef,
    );
  }

}
