// 조회수
// 단위 : 하루
// 저장 방법: createdAt의 연/월/일이 일치하는 문서가 있으면 추가, 없으면 생성
// memoryViews에 memoryDocId : views 꼴로 저장, 갱신
import 'package:atti/data/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

class ViewsModel {
  // 자료형
  final _db = FirebaseFirestore.instance;
  DocumentReference? patientId;
  Timestamp? createdAt;
  DocumentReference? memoryReference; // memoryViews에 저장하기 위해 받는 정보
  Map<DocumentReference, int>? memoryViews;
  DocumentReference? reference; // document 식별자

  // 생성자
  ViewsModel({
    this.memoryReference,
  });

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientId'] = patientId;
    map['createdAt'] = createdAt;
    map['memoryViews'] = memoryViews?.map((key, value) => MapEntry(key.path, value));
    map['reference'] = reference?.path;
    return map;
  }

// json -> object (Firestore -> Flutter)
  ViewsModel.fromJson(dynamic json, this.reference) {
    patientId = json['patientId'];
    createdAt = json['createdAt'];
    memoryViews = (json['memoryViews'] as Map)?.map((key, value) => MapEntry(_db.doc(key), value));
    reference = _db.doc(json['reference']);
  }

  // Named Constructor with Initializer
  ViewsModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // Named Constructor with Initializer
  ViewsModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);
}


class ViewsService {
  final _db = FirebaseFirestore.instance;
  final AuthController _authController = AuthController();
  Future<void> addViews(ViewsModel views) async {
    try {
      // 메모리를 조회한 유저 정보 받아오기 (환자일 경우에만)
      QuerySnapshot userSnapshot = await _db
          .collection('user')
          .where('userId', isEqualTo: _authController.loggedUser)
          .where('isPatient', isEqualTo: _authController.isPatient)
          .get();
        if (userSnapshot.size > 0 && userSnapshot.docs[0]['isPatient']) {
          // 오늘 날짜의 views Doc이 이미 존재하는지 확인
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day); // 시간, 분, 초, 밀리초는 모두 0으로 설정
          DateTime nextDay = DateTime(today.year, today.month, today.day + 1); // 설정한 날짜의 다음 날을 계산
          // 환자인 경우에만 이후 과정 진행
          // 유저 정보, 기간을 기준으로 문서 검색
          DocumentReference patientRef = userSnapshot.docs[0]['reference'];
          QuerySnapshot snapshot = await _db
              .collection('views')
              .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(today)) // 설정한 날짜 이후의 문서를 찾습니다.
              .where('createdAt', isLessThan: Timestamp.fromDate(nextDay)) // 다음 날 이전의 문서를 찾습니다.
              .where('patientId', isEqualTo: patientRef)
              .get();
          // Doc이 이미 존재한다면 : Doc 갱신
          if (snapshot.docs.length > 0) {
            DocumentSnapshot document = snapshot.docs[0];
            ViewsModel existingViews = ViewsModel.fromSnapShot(document as DocumentSnapshot<Map<String, dynamic>>);
            if (existingViews.memoryViews == null) {
              existingViews.memoryViews = {};
            }
            existingViews.memoryViews![views.memoryReference!] =
                (existingViews.memoryViews![views.memoryReference!] ?? 0) + 1; // memoryViews를 1 증가
            await document.reference.update(existingViews.toJson()); // 변경된 정보를 업데이트
          }
          // Doc이 존재하지 않는다면 : Doc 추가
          else {
            views.createdAt = Timestamp.now();
            views.memoryViews = {
              views.memoryReference!: 1 // memoryViews를 초기화
            };
            views.patientId = userSnapshot.docs[0]['reference'];
            print(userSnapshot.docs[0]['reference'].path);
            DocumentReference docRef = await _db.collection('views').add(views.toJson());
            views.reference = docRef;
            await docRef.update(views.toJson());
          }
        }
     } catch (e) {
      print('Error adding views: $e');
    }
  }
}


class ViewsController extends GetxController {
  final ViewsService viewsService = ViewsService();
  var views = ViewsModel().obs;
  var tmpName = ''.obs;

  ViewsController(DocumentReference memoryReference) {
    views = ViewsModel(memoryReference: memoryReference).obs;
  }

  void addViews() async {
    try {
      await viewsService.addViews(views.value);
      clear();
    } catch (e) {
      print('Error adding views: $e');
    }
  }

  void clear() {
    views.value = ViewsModel();
  }
}