import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class MemoryNoteService {
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
      await firestore.collection('memoryNote').add(memoryNote.toJson());
    } catch (e) {
      print('Error adding memory note: $e');
    }
  }
}