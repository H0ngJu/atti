// 리포트용으로 저장할 컨트롤러...
// cloudfunction 사용
// 단위 : 일주일
// 1. 미완료 루틴
// 2. 등록 기억 수 (지금 구현)
// 3. 감정 키워드 (제일 나중에)
// 4. 많이 열람한 기억 (지금 구현)
// 저장 방법: createdAt의 시작 요일은 월요일, -7일 안에 일치하는 문서가 있으면 추가, 없으면 생성 (요일 기준은 일요일, 지난 주 월 ~ 토요일 문서!)
// 사용 방법 :
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final _db = FirebaseFirestore.instance;
  // 자료형
  DocumentReference? patientId;
  Timestamp? createdAt;
  // List<DocumentReference>? unfinishedRoutine;
  int? registeredMemoryNumber;
  // List<String>? emotionKeyword;
  List<DocumentReference>? MostViewMemories;
  List<Timestamp>? period;
  DocumentReference? reference; // document 식별자

  // 생성자
  ReportModel({
    this.patientId,
  });

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientId'] = patientId?.path;
    map['createdAt'] = createdAt;
    map['reference'] = reference?.path;
    return map;
  }

// json -> object (Firestore -> Flutter)
  ReportModel.fromJson(dynamic json, this.reference) {
    patientId = _db.doc(json['patientId']);
    createdAt = json['createdAt'];
    reference = _db.doc(json['reference']);
  }

  // Named Constructor with Initializer
  ReportModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // Named Constructor with Initializer
  ReportModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);
}


class ReportService {
  final _db = FirebaseFirestore.instance;
  Future<void> addReport(ReportModel report) async {
    try {
      // 오늘 날짜의 views Doc이 이미 존재하는지 확인
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day); // 시간, 분, 초, 밀리초는 모두 0으로 설정
      DateTime nextDay = DateTime(today.year, today.month, today.day + 1); // 설정한 날짜의 다음 날을 계산
      QuerySnapshot snapshot = await _db
          .collection('views')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(today)) // 설정한 날짜 이후의 문서를 찾습니다.
          .where('createdAt', isLessThan: Timestamp.fromDate(nextDay)) // 다음 날 이전의 문서를 찾습니다.
          .get();
      // Doc이 이미 존재한다면 : Doc 갱신
      if (snapshot.docs.length > 0) {
        DocumentSnapshot document = snapshot.docs[0];
        ReportModel existingViews = ReportModel.fromSnapShot(document as DocumentSnapshot<Map<String, dynamic>>);
        if (existingViews.memoryViews == null) {
          existingViews.memoryViews = {};
        }
        existingViews.memoryViews![report.memoryReference!] =
            (existingViews.memoryViews![report.memoryReference!] ?? 0) + 1; // memoryViews를 1 증가시킵니다.
        await document.reference.update(existingViews.toJson()); // 변경된 정보를 업데이트합니다.
      }
      // Doc이 존재하지 않는다면 : Doc 추가
      else {
        report.createdAt = Timestamp.now();
        report.memoryViews = {
          report.memoryReference!: 1 // memoryViews를 초기화합니다.
        };
        DocumentReference docRef = await _db.collection('report').add(report.toJson());
        report.reference = docRef;
        await docRef.update(report.toJson());
      }
    } catch (e) {
      print('Error adding report: $e');
    }
  }
}


class ViewsController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final ReportService reportService = ReportService();
  var report = ReportModel().obs;
  var tmpName = ''.obs;

  ViewsController(DocumentReference patientId, DocumentReference memoryReference) {
    report = ReportModel(patientId: patientId, memoryReference: memoryReference).obs;
  }

  void addViews() async {
    try {
      await reportService.addReport(report.value);
      clear();
    } catch (e) {
      print('Error adding report: $e');
    }
  }

  void clear() {
    report.value = ReportModel();
  }


}