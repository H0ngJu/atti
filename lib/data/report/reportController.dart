import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'dart:core';

// class ReportModel {
//   // 자료형
//   Timestamp? createdAt;
//   DocumentReference<Map<String, dynamic>>? patientId;
//   Map<String, dynamic>? mostViews;
//   List<Map<String, dynamic>>? unfinishedRoutine;
//   List<Map<String, dynamic>>? unfinishedSchedule;
//   Map<String, dynamic>? registeredMemoryCount;
//   List<String>? reportPeriod;
//   routineCompletion;
//   scheduleCompletion;
//   Map<String, int>weeklyEmotion;
//
//   // json -> object (Firestore -> Flutter)
//   ReportModel.fromJson(dynamic json) {
//     createdAt = json['createdAt'];
//     // patientId 필드를 DocumentReference로 안전하게 캐스팅
//     patientId = json['patientId'] as DocumentReference<Map<String, dynamic>>;
//     mostViews = json['mostViews'] as Map<String, dynamic>? ?? {};
//     unfinishedRoutine = (json['unfinishedRoutine'] as List<dynamic>?)
//         ?.map((item) => Map<String, dynamic>.from(item))
//         .toList() ?? [];
//     registeredMemoryCount = json['registeredMemoryCount'] as Map<String, dynamic>? ?? {};
//   }
//
//   // Named Constructor with Initializer
//   // snapshot 자료가 들어오면 이걸 다시 Initializer를 통해 fromJson Named Constructor를 실행함
//   ReportModel.fromSnapShot(DocumentSnapshot<Object?> snapshot)
//       : this.fromJson(snapshot.data() as Map<String, dynamic>? ?? {});
//
//   // Named Constructor with Initializer
//   // 컬렉션 내에 특정 조건을 만족하는 데이터를 다 가지고 올때 사용
//   ReportModel.fromQuerySnapshot(
//       QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!);
//
//   // object -> json (Flutter -> Firebase)
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['createdAt'] = createdAt;
//     map['patientId'] = patientId;
//     map['mostViews'] = mostViews;
//     map['unfinishedRoutine'] = unfinishedRoutine;
//     map['registeredMemoryCount'] = registeredMemoryCount;
//     return map;
//   }
// }
//
// class ReportController {
//   final AuthController authController = Get.put(AuthController());
//   final _db = FirebaseFirestore.instance;
//   final _authentication = FirebaseAuth.instance;
//   // 레포트 가져오기
//   Future<List<ReportModel>> getReport() async {
//     try {
//       // 보호자 uid
//       User? user = _authentication.currentUser;
//       List<ReportModel> reports = [];
//       print(user!.uid);
//       // 보호자 도큐먼트 받아오기 : uid로 userId 일치하는 user Doc 가져오기
//       QuerySnapshot userSnapshot;
//       if (user != null) {
//         userSnapshot = await _db.collection('user')
//             .where('userId', isEqualTo: user.uid)
//             .get();
//         if (userSnapshot.docs.length > 0) {
//           // 보호자 도큐먼트 내 patientId로 레포트 쿼리
//           DocumentReference patientRef = _db.doc("user/"+userSnapshot.docs[0]["patientDocId"]);
//           QuerySnapshot reportsSnapshot = await _db.collection('report')
//               .where('patientId', isEqualTo: patientRef)
//               .get();
//           reportsSnapshot.docs.forEach((doc) {
//             reports.add(ReportModel.fromSnapShot(doc));
//           });
//         }
//       }
//       else {
//         print("error : logged user doesn't exist");
//       }
//       return reports;
//     } catch (e) {
//       print('Error getting reports : $e');
//       return [];
//     }
//   }
// }

class ReportController {
  // Timestamp? createdAt;
  // DocumentReference<Map<String, dynamic>>? patientId;
  // Map<String, dynamic>? mostViews;
  // List<Map<String, dynamic>>? unfinishedRoutine;
  // List<Map<String, dynamic>>? unfinishedSchedule;
  // Map<String, dynamic>? registeredMemoryCount;
  // List<String>? reportPeriod;
  // var routineCompletion;
  // var scheduleCompletion;
  // Map<String, int>? weeklyEmotion;
  //
  // final AuthController authController = Get.put(AuthController());
  final _db = FirebaseFirestore.instance;
  final _authentication = FirebaseAuth.instance;
  // 레포트 가져오기
  Future<List<dynamic>> getReport() async {
    try {
      // 보호자 uid
      User? user = _authentication.currentUser;
      List<dynamic> reportsData = [];
      print(user!.uid);
      // 보호자 도큐먼트 받아오기 : uid로 userId 일치하는 user Doc 가져오기
      QuerySnapshot userSnapshot;
      if (user != null) {
        userSnapshot = await _db.collection('user')
            .where('userId', isEqualTo: user.uid)
            .get();
        if (userSnapshot.docs.length > 0) {
          // 보호자 도큐먼트 내 patientId로 레포트 쿼리
          DocumentReference patientRef = _db.doc("user/"+userSnapshot.docs[0]["patientDocId"]);
          QuerySnapshot reportsSnapshot = await _db.collection('report')
              .where('patientId', isEqualTo: patientRef)
              .get();
          // 문서의 data()를 추출하여 List<Map<String, dynamic>>로 변환
          reportsData = reportsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        }
      }
      else {
        print("error : logged user doesn't exist");
      }
      return reportsData;
    } catch (e) {
      print('Error getting reports : $e');
      return [];
    }
  }
}

// 1. 리포트 페이지에 들어가면 보호자의 user doc을 찾아 patient Doc Id를 찾는다
// 2. patient Doc Id와 일치하는 patientId를 가진 report doc을 찾는다.
// 3. report doc의 문서를 찾아와 보여준다.