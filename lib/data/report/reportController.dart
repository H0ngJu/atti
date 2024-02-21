import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'dart:core';

class ReportModel {
  // 자료형
  Timestamp? createdAt;
  String? patientId;
  Map<String, dynamic>? mostViews; // ++
  List<Map<String, dynamic>>? unfinishedRoutine;
  Map<String, dynamic>? registeredMemoryCount;
  DocumentReference? reference; // document 식별자
  final _db = FirebaseFirestore.instance; // ++
  // json -> object (Firestore -> Flutter)
  ReportModel.fromJson(dynamic json, this.reference) {
    createdAt = json['createdAt'];
    patientId = json['patientId'];
    // patientId = _db.doc(json['patientId']); // ++
    mostViews = json['mostViews'] as Map<String, dynamic>;
    unfinishedRoutine = List<Map<String, String>>.from(json['unfinishedRoutine'].map((item) => Map<String, String>.from(item)));
    registeredMemoryCount = json['registeredMemoryCount'] as Map<String, dynamic>; // 수정된 부분
    // unfinishedRoutine = json['unfinishedRoutine'];
    // registeredMemoryCount = json['registeredMemoryCount'];
    reference = json['reference'];
  }

  // Named Constructor with Initializer
  // snapshot 자료가 들어오면 이걸 다시 Initializer를 통해 fromJson Named Constructor를 실행함
  ReportModel.fromSnapShot(DocumentSnapshot<Object?> snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.reference);


  // Named Constructor with Initializer
  // 컬렉션 내에 특정 조건을 만족하는 데이터를 다 가지고 올때 사용
  ReportModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdAt'] = createdAt;
    map['patientId'] = patientId;
    map['mostViews'] = mostViews;
    map['unfinishedRoutine'] = unfinishedRoutine;
    map['registeredMemoryCount'] = registeredMemoryCount;
    map['reference'] = reference;
    return map;
  }
}

class ReportController {
  final AuthController authController = Get.put(AuthController());
  final _db = FirebaseFirestore.instance;
  final _authentication = FirebaseAuth.instance;
  // 레포트 가져오기
  Future<List<ReportModel>> getReport() async {
    try {
      // 보호자 uid
      User? user = _authentication.currentUser;
      List<ReportModel> reports = [];
      print(user!.uid);
      // 보호자 도큐먼트 받아오기
      QuerySnapshot userSnapshot = await _db.collection('user')
          .where('userId', isEqualTo: user.uid)
          .get();
      if (userSnapshot.docs.length > 0) {
        // 보호자 도큐먼트 내 patientId로 레포트 쿼리
        DocumentReference patientRef = _db.doc("user/"+userSnapshot.docs[0]["patientDocId"]);
        QuerySnapshot reportsSnapshot = await _db.collection('report')
            .where('patientId', isEqualTo: "/user/"+patientRef.id)
            .get();
        reportsSnapshot.docs.forEach((doc) {
          // add함수에서 문제가 발생하는듯
          reports.add(ReportModel.fromSnapShot(doc));
        });
      }
      return reports;
    } catch (e) {
      print('Error getting reports : $e');
      return [];
    }
  }
}