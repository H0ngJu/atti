import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/memory/memory_note_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../auth_controller.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  // 기억 등록하기 및 도큐먼트 레퍼런스 반환
  Future<DocumentReference> addMemoryNote(MemoryNoteModel memoryNote) async {
    try {
      String imageUrl = await uploadImage(memoryNote.img!);

      // Firestore에 데이터 추가
      memoryNote.img = imageUrl; // img 필드를 업로드된 이미지의 URL로 업데이트
      memoryNote.createdAt = Timestamp.now();
      memoryNote.patientId = authController.patientDocRef;

      DocumentReference docRef = await firestore.collection('memoryNote').add(memoryNote.toJson()); // 도큐먼트 추가하고 레퍼런스 받기
      memoryNote.reference = docRef; // 도큐먼트 ID 저장
      await docRef.update(memoryNote.toJson()); // 도큐먼트 업데이트

      return docRef; // 도큐먼트 레퍼런스 반환
    } catch (e) {
      print('Error adding memory note: $e');
      rethrow; // 예외 다시 던지기
    }
  }

  // 이미지 URL을 다운로드하고 바이트 데이터로 반환
  Future<List<int>> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('이미지 다운로드 실패: ${response.statusCode}');
    }
  }

  // 기억 이미지에 대한 설명 텍스트 생성하여 저장하기
  Future<void> callGeminiAPI(MemoryNoteModel memoryNote, DocumentReference docRef) async {
    await dotenv.load(fileName: '.env');
    final String apiKey = dotenv.env['GEMINI_API_KEY']!;
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    // 이미지 처리
    final visionModel = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: apiKey,);
    var startTime = DateTime.now(); //
    final userMemoryImg = Uint8List.fromList(await _downloadImage(memoryNote.img!));
    var endTime = DateTime.now(); //
    print('이미지 다운로드 시간: ${endTime.difference(startTime)}');

    final imgPrompt = TextPart("이미지에 대해 자세히 설명해줘.");
    final imageParts = [DataPart('image/jpeg', userMemoryImg)];
    startTime = DateTime.now();
    final imgDescription = await visionModel.generateContent([Content.multi([imgPrompt, ...imageParts])]);
    endTime = DateTime.now();
    print('이미지 설명 생성 시간: ${endTime.difference(startTime)}');
    print(imgDescription.text);

    await docRef.update({'imgDescription': imgDescription.text});
  }

  // 감정 키워드 저장하기
  Future<void> addEmotionKeyword(List<String> emotions) async {

  }

  // 위험 단어 저장하기
  Future<void> addDangerWords(List<String> dangerWords) async {

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