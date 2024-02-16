import 'package:get/get.dart';
import 'package:atti/data/routine/routine_model.dart';
import 'package:atti/data/routine/routine_service.dart';

class RoutineController extends GetxController {
  final RoutineService routineService = RoutineService();
  var routine = RoutineModel().obs;
  var tmpRoutineName = ''.obs;

  void addRoutine() async {
    try {
      await routineService.addRoutine(routine.value);
      clear();
    } catch (e) {
      print('Error adding routine: $e');
    }
  }
  void clear() {
    routine.value = RoutineModel();
  }


}
