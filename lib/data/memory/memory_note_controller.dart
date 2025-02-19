import 'package:atti/index.dart';

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

  // 새로운 updateMemoryNote() 함수
  void updateMemoryNote(DocumentReference reference) async {
    try {
      // 기존 기억의 도큐먼트 레퍼런스가 있는지 확인
      await memoryNoteService.updateMemoryNote(
        reference,
        {
          'era': memoryNote.value.era,
          'imgTitle': memoryNote.value.imgTitle,
          'keyword': memoryNote.value.keyword,
          'selectedFamilyMember': memoryNote.value.selectedFamilyMember,
        },
      );
      print("Memory note updated successfully.");
    } catch (e) {
      print('Error updating memory note: $e');
    }
  }

  void clear() {
    memoryNote.value = MemoryNoteModel(
      patientId: authController.patientDocRef,
    );
  }

}
