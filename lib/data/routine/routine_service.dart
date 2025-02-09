import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:atti/data/routine/routine_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../main.dart';
import '../auth_controller.dart';
import 'dart:core';

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
  Future<RoutineModel> addRoutine(RoutineModel routine) async {
    try {
      String imageUrl = await uploadImage(routine.img!);
      routine.img = imageUrl; // 업로드된 이미지 url로 img필드 업데이트
      routine.createdAt = Timestamp.now();
      routine.patientId = authController.patientDocRef;
      routine.isPatient = authController.isPatient;

      print("addRoutine 함수 안!!!!");
      print(authController.patientDocRef);

      // // 추가 *************************
      routine.isFinished = createTimeMap(routine.repeatDays);
      // // 추가 *************************

      DocumentReference docRef =
          await firestore.collection('routine').add(routine.toJson());
      routine.reference = docRef;
      await docRef.update(routine.toJson());
      return routine;
    } catch (e) {
      print('Error adding notification : $e!!!!!!!!!!!!!!!!!!');
      throw Future.error('Error adding routine : $e');
    }
  }

  Map<String, bool> createTimeMap(List<String>? days) {
    Map<String, bool> timeMap = {};
    DateTime now = DateTime.now();
    DateTime oneYearFromNow = DateTime(now.year + 1, now.month, now.day);
    if (days != null) {
      for (var i = 0; i < 365; i++) {
        DateTime date = DateTime(now.year, now.month, now.day + i);
        String dayOfWeek = getDayOfWeek(date.weekday);

        if (days.contains(dayOfWeek) && date.isBefore(oneYearFromNow)) {
          timeMap[DateTime(date.year, date.month, date.day).toString()] = false;
        }
      }
    }
    return timeMap;
  }

  String getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
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
      DocumentSnapshot<Object?> snapshot = await docRef.get();

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('isFinished')) {
        if (data['isFinished'] is Map<String, dynamic>) { // 맵 형태인지 확인합니다.
          Map<String, dynamic> finishedMap = Map<String, dynamic>.from(data['isFinished']!);

          String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 00:00:00.000';
          //String dateString = DateTime(date.year, date.month, date.day).toString();

          finishedMap[dateString] = true;
          await docRef.update({'isFinished': finishedMap});

          print('Routine completed successfully!');
        } else {
          print('Error completing routine: isFinished field is not of type Map<String, dynamic>.');
        }
      } else {
        print('Error completing routine: isFinished field does not exist or is null.');
      }
    } catch (e) {
      print('Error completing routine: $e');
    }
  }
  // 지정된 날짜 범위 내의 루틴 가져오기
  Future<List<RoutineModel>> getRoutinesInRange(DateTime startDate, DateTime endDate) async {
    try {
      // 시작 날짜와 종료 날짜를 String 형태로 변환합니다.
      String startString = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      String endString = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

      // Firestore에서 조건에 맞는 문서들을 조회합니다.
      QuerySnapshot querySnapshot = await firestore
          .collection('routine')
          .where('patientId', isEqualTo: authController.patientDocRef)
          .get();

      List<RoutineModel> routines = [];

      // 문서들을 순회하면서 조건에 맞는지 확인합니다.
      for (var doc in querySnapshot.docs) {
        RoutineModel routine = RoutineModel.fromJson(doc.data() as Map<String, dynamic>, doc.reference);

        // 루틴의 isFinished 맵을 순회하면서 날짜 범위 내에 완료되지 않은 루틴이 있는지 확인합니다.
        bool isInDateRange = routine.isFinished!.entries.any((entry) {
          DateTime entryDate = DateTime.parse(entry.key);
          return entryDate.isAfter(DateTime.parse(startString)) && entryDate.isBefore(DateTime.parse(endString)) && !entry.value;
        });

        // 조건에 맞는 경우 리스트에 추가합니다.
        if (isInDateRange) {
          routines.add(routine);
        }
      }

      // 반환하기 전에, 루틴을 시간 순서대로 정렬합니다.
      routines.sort((a, b) {
        List<int>? timeA = a.time;
        List<int>? timeB = b.time;
        if (timeA![0] != timeB![0]) {
          return timeA[0].compareTo(timeB[0]);
        } else {
          return timeA[1].compareTo(timeB[1]);
        }
      });

      return routines;
    } catch (e) {
      print('Error getting routines in date range: $e');
      return [];
    }
  }

  // 특정 루틴 삭제
  Future<void> deleteRoutine(DocumentReference docRef) async {
    try {
      // Firestore에서 문서를 삭제
      await docRef.delete();
      await flutterLocalNotificationsPlugin.cancel(docRef.id.hashCode);
      print('Routine deleted successfully!');
    } catch (e) {
      print('Error deleting routine: $e');
    }
  }


}
