import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/data/memory/memory_note_service.dart';
import '../auth_controller.dart';
i


class MemoryNoteController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final MemoryNoteService memoryNoteService = MemoryNoteService();
  var memoryNote = MemoryNoteModel().obs;
  var tmpImgTitle = ''.obs;

  void addMemoryNote() async {
    try {
      await memoryNoteService.addMemoryNote(memoryNote.value);
      clear();
    } catch (e) {
      print('Error adding memory note: $e');
    }
  }

  void clear() {
    memoryNote.value = MemoryNoteModel(
      patientId: authController.patientDocRef,
    );
  }

}
