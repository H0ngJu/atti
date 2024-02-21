import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../auth_controller.dart';
import 'package:get/get.dart';


class MemoryNoteService {
  final AuthController authController = Get.put(AuthController());
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<String> uploadImage(String imagePath) async {
    File file = File(imagePath); // 이미지 파일 객체
    try {
      // Firebase Storage에 이미지 업로드
      UploadTask task = storage
          .ref('memory/$imagePath') // 저장할 경로 지정
          .putFile(file); // 파일 업로드

      TaskSnapshot snapshot = await task; // 업로드 완료를 기다림

      return await snapshot.ref.getDownloadURL(); // 이미지 URL 반환
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // 기억 등록하기
  Future<void> addMemoryNote(MemoryNoteModel memoryNote) async {
    try {
      String imageUrl = await uploadImage(memoryNote.img!);

      // Firestore에 데이터 추가
      memoryNote.img = imageUrl; // img 필드를 업로드된 이미지의 URL로 업데이트
      memoryNote.createdAt = Timestamp.now();
      memoryNote.patientId = authController.patientDocRef;

      DocumentReference docRef = await firestore.collection('memoryNote').add(memoryNote.toJson()); // 도큐먼트 추가하고 레퍼런스 받기
      memoryNote.reference = docRef; // 도큐먼트 ID 저장
      await docRef.update(memoryNote.toJson()); // 도큐먼트 업데이트
    } catch (e) {
      print('Error adding memory note: $e');
    }
  }

  // 기억 가져오기
  Future<List<MemoryNoteModel>> getMemoryNote() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('memoryNote')
          .where('patientId', isEqualTo: authController.patientDocRef)
          .orderBy('createdAt', descending: true)
          .get();

      List<MemoryNoteModel> memoryNotes = [];
      querySnapshot.docs.forEach((doc) {
        memoryNotes.add(MemoryNoteModel.fromSnapShot(doc as DocumentSnapshot<Map<String, dynamic>>));
      });
      return memoryNotes;
    } catch (e) {
      print('Error getting memory note : $e');
      return [];
    }
  }
}