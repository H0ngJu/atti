// 루틴 완료 여부
// 저장 방법: 루틴 생성 시 자동 생성
// isFinished : Timestamp - bool 쌍으로 시간, 일자 별 완료 여부 생성
import 'package:atti/data/auth_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IsFinishedModel {
  // 자료형
  final _db = FirebaseFirestore.instance;
  DocumentReference? patientId;
  Timestamp? createdAt;
  DocumentReference? routineReference; // isFinished에 저장하기 위해 받는 정보
  Map<DateTime, bool>? isFinisedMap; // 일자 : 완료 여부
  List<String>? days; // 반복 요일
  DocumentReference? reference; // document 식별자

  // 생성자
  IsFinishedModel({
    this.patientId,
    this.routineReference,
    this.days,
  });

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientId'] = patientId?.path;
    map['createdAt'] = createdAt;
    map['isFinisedMap'] = isFinisedMap;
    map['reference'] = reference?.path;
    return map;
  }

// json -> object (Firestore -> Flutter)
  IsFinishedModel.fromJson(dynamic json, this.reference) {
    patientId = _db.doc(json['patientId']);
    createdAt = json['createdAt'];
    isFinisedMap = json['isFinisedMap'];
    reference = _db.doc(json['reference']);
  }

  // Named Constructor with Initializer
  IsFinishedModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // Named Constructor with Initializer
  IsFinishedModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);
}


class IsFinishedService {
  final _db = FirebaseFirestore.instance;
  final AuthController authController = Get.put(AuthController());
  Future<void> addIsFinished(IsFinishedModel isFinished) async {
    try {
      isFinished.patientId = authController.patientDocRef;
      isFinished.createdAt = Timestamp.now();
      isFinished.isFinisedMap = createTimeMap(isFinished.days);
      DocumentReference docRef = await _db.collection('isFinished').add(isFinished.toJson());
      isFinished.reference = docRef;
      await docRef.update(isFinished.toJson());
    } catch (e) {
      print('Error adding isFinished: $e');
    }
  }

  // Map isFinished 생성 함수
  Map<DateTime, bool> createTimeMap(List<String>? days) {
    Map<DateTime, bool> timeMap = {};
    DateTime now = DateTime.now();
    DateTime oneYearFromNow = DateTime(now.year + 1, now.month, now.day);
    if (days != null) {
      for (var i = 0; i < 365; i++) {
        DateTime date = DateTime(now.year, now.month, now.day + i);
        String dayOfWeek = getDayOfWeek(date.weekday);

        if (days.contains(dayOfWeek) && date.isBefore(oneYearFromNow)) {
          timeMap[DateTime(date.year, date.month, date.day)] = false;
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
}


class IsFinishedController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final IsFinishedService isFinishedService = IsFinishedService();
  var isFinished = IsFinishedModel().obs;
  var tmpName = ''.obs;

  IsFinishedController(DocumentReference patientId, DocumentReference routineReference, List<String> days) {
    isFinished = IsFinishedModel(patientId: patientId, routineReference: routineReference, days: days).obs;
  }

  // 루틴 생성 시 불러올 함수, isFinisehd
  void addIsFinished() async {
    try {
      await isFinishedService.addIsFinished(isFinished.value);
      clear();
    } catch (e) {
      print('Error adding isFinished: $e');
    }
  }

  void clear() {
    isFinished.value = IsFinishedModel();
  }

}