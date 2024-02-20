import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class ReportModel {
  // 자료형
  Timestamp? createdAt;
  DocumentReference? patientId;
  Map<DocumentReference, int>? mostViews;
  List<Map<String, dynamic>>? unfinishedRoutine;
  int? registeredMemoryCount;
  DocumentReference? reference; // document 식별자

  // 생성자
  ReportModel({
    this.createdAt,
    this.patientId,
    this.mostViews,
    this.unfinishedRoutine,
    this.registeredMemoryCount,
    this.reference
  });

  // json -> object (Firestore -> Flutter)
  ReportModel.fromJson(dynamic json, this.reference) {
    createdAt = json['createdAt'];
    patientId = json['patientId'];
    mostViews = json['mostViews'];
    unfinishedRoutine = json['unfinishedRoutine'];
    registeredMemoryCount = json['registeredMemoryCount'];
    reference = json['reference'];
  }

  // Named Constructor with Initializer
  // snapshot 자료가 들어오면 이걸 다시 Initializer를 통해 fromJson Named Constructor를 실행함
  ReportModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

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

  // 레포트 가져오기
  Future<List<ReportModel>> getReport() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('reports')
          .where('patientId', isEqualTo: authController.patientDocRef)
          .get();

      List<ReportModel> reports = [];
      querySnapshot.docs.forEach((doc) {
        reports.add(ReportModel.fromSnapShot(doc as DocumentSnapshot<Map<String, dynamic>>));
      });
      return reports;
    } catch (e) {
      print('Error getting reports : $e');
      return [];
    }
  }
}