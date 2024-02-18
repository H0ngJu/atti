import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/routine/routine_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import '../auth_controller.dart';

class RoutineService {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final AuthController authController = Get.put(AuthController());

  // 이미지 업로드
  Future<String> uploadImage(String imagePath) async {
    File file = File(imagePath);
    try {
      UploadTask task = storage
          .ref('routine/$imagePath')
          .putFile(file);

      TaskSnapshot snapshot = await task;
      return await snapshot.ref.getDownloadURL(); // 이미지 URL 반환
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // 루틴 등록
  Future<void> addRoutine(RoutineModel routine) async {
    try {
      String imageUrl = await uploadImage(routine.img!);
      routine.img = imageUrl; // 업로드된 이미지 url로 img필드 업데이트
      routine.createdAt = Timestamp.now();
      routine.patientId = authController.patientDocRef;

      DocumentReference docRef =
          await firestore.collection('routine').add(routine.toJson());
      routine.reference = docRef;
      await docRef.update(routine.toJson());
    } catch (e) {
      print('Error adding schedule : $e');
    }
  }

  // 특정 요일의 루틴 가져오기
  Future<List<RoutineModel>> getRoutinesByDay(String day) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('routine')
          .where('repeatDays', arrayContains: day)
          .where('patientId', isEqualTo: authController.patientDocRef)
          .get();

      List<RoutineModel> routines = querySnapshot.docs
          .map((doc) => RoutineModel.fromJson(doc.data(), doc.reference))
          .toList();

      // 시간으로 정렬
      routines.sort((a, b) {
        // a와 b의 시간을 가져옴
        List<int> timeA = a.time!;
        List<int> timeB = b.time!;

        // 시간을 비교하여 정렬
        if (timeA[0] != timeB[0]) {
          return timeA[0].compareTo(timeB[0]); // 시간 비교
        } else {
          return timeA[1].compareTo(timeB[1]); // 분 비교
        }
      });
      return routines;
    } catch (e) {
      print('Error getting routines by day: $e');
      return [];
    }
  }


  // 루틴 완료
  Future<void> completeRoutine(DocumentReference docRef, DateTime date) async {
    try {
      // 도큐먼트 가져오기
      DocumentSnapshot snapshot = await docRef.get();

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('isFinished')) {
        if (data['isFinished'] is List<dynamic>) { // List<String> 대신 List<dynamic>을 확인합니다.
          List<dynamic> finishedDates = List<dynamic>.from(data['isFinished']!);

          finishedDates.add(date.toString());

          Map<String, dynamic> updateData = {'isFinished': finishedDates};
          await docRef.update(updateData);

          print('Routine completed successfully!');
        } else {
          print('Error completing routine: isFinished field is not of type List<dynamic>.');
        }
      } else {
        print('Error completing routine: isFinished field does not exist or is null.');
      }
    } catch (e) {
      print('Error completing routine: $e');
    }
  }



}
