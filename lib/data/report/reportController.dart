import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

class ReportController {

  final _db = FirebaseFirestore.instance;
  final _authentication = FirebaseAuth.instance;
  // 레포트 가져오기
  Future<List<dynamic>> getReport() async {
    try {
      // 보호자 uid
      User? user = _authentication.currentUser;
      List<dynamic> reportsData = [];
      // 보호자 도큐먼트 받아오기 : uid로 userId 일치하는 user Doc 가져오기
      QuerySnapshot userSnapshot;
      if (user != null) {
        userSnapshot = await _db.collection('user')
            .where('userId', isEqualTo: user.uid)
            .get();
        if (userSnapshot.docs.isNotEmpty) {
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