import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:atti/data/memory/memory_note_service.dart';
import '../auth_controller.dart';

class MemoryNoteController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final MemoryNoteService memoryNoteService = MemoryNoteService();
  var memoryNote = MemoryNoteModel().obs;
  var tmpImgTitle = ''.obs;
  var documentReference; // 도큐먼트 레퍼런스를 저장할 변수 추가

  void addMemoryNote() async {
    try {
      documentReference = await memoryNoteService.addMemoryNote(memoryNote.value);
      await memoryNoteService.callGeminiAPI(memoryNote.value, documentReference);

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
