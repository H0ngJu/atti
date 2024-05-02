import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class DangerWordModel {
  DocumentReference? patientDocRef;
  List<String>? dangerWordsList;
  Timestamp? createdAt;
  DocumentReference? reference; // document 식별자

  DangerWordModel({
    this.patientDocRef,
    this.dangerWordsList,
    this.createdAt,
    this.reference
  });

  DangerWordModel.fromJson(dynamic json, this.reference) {
    patientDocRef = json['patientDocRef'];
    dangerWordsList = json['dangerWordsList'] != null
        ? List<String>.from(json['dangerWordsList'])
        : [];
    createdAt = json['createdAt'];
    reference = json['reference'];
  }

  DangerWordModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  DangerWordModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientDocRef'] = patientDocRef;
    map['dangerWordsList'] = dangerWordsList;
    map['createdAt'] = createdAt;
    map['reference'] = reference;
    return map;
  }
}


class DangerWordService {
  final AuthController authController = Get.put(AuthController());
  final firestore = FirebaseFirestore.instance;

  Future<void> addDangerWord(DangerWordModel dangerWord) async {
    // 현재 주의 시작 및 끝 날짜 계산 (월요일부터 일요일까지의 날짜)
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = monday.add(Duration(days: 6));

    // 해당 주의 시작 및 끝을 Timestamp로 변환
    Timestamp startOfWeek = Timestamp.fromDate(monday);
    Timestamp endOfWeek = Timestamp.fromDate(sunday);

    CollectionReference weeklyDangerWordCollection = firestore.collection('dangerWord');
    QuerySnapshot querySnapshot = await weeklyDangerWordCollection
        .where('patientDocRef', isEqualTo: authController.patientDocRef)
        .where('createdAt', isGreaterThanOrEqualTo: startOfWeek)
        .where('createdAt', isLessThanOrEqualTo: endOfWeek)
        .get();

    if (querySnapshot.docs.isNotEmpty) { // 해당 주의 도큐먼트가 존재하는 경우 -> 업데이트
      DocumentReference docRef = querySnapshot.docs.first.reference;
      List<String> currentDangerWordsList =
      List<String>.from(querySnapshot.docs.first.get('dangerWordsList'));

      // 중복을 제거한 새로운 위험 단어 목록을 생성
      List<String> newDangerWordsList = currentDangerWordsList.toSet().toList();
      newDangerWordsList.addAll(dangerWord.dangerWordsList!);

      await docRef.update({'dangerWordsList': newDangerWordsList});
    } else { // 존재하지 않는 경우 -> 생성
      DocumentReference docRef = await weeklyDangerWordCollection.add({
        'createdAt': Timestamp.now(),
        'dangerWordsList': dangerWord.dangerWordsList,
        'patientDocRef': authController.patientDocRef
      });
      dangerWord.reference = docRef;
      await docRef.update(dangerWord.toJson());
    }
  }
}


class DangerWordController {
  final AuthController authController = Get.put(AuthController());
  final DangerWordService dangerWordService = DangerWordService();
  var dangerWord = DangerWordModel().obs();
  var documentReference;

  void addDangerWord(List<String> dangerWordsList) async {
    try {
      DangerWordModel dangerWordModel = DangerWordModel(
          patientDocRef: authController.patientDocRef,
          createdAt: Timestamp.now(),
          dangerWordsList: dangerWordsList
      );
      await dangerWordService.addDangerWord(dangerWordModel);
      clear();
    } catch (e) {
      print('Error adding danger word: $e');
    }
  }

  void clear() {
    dangerWord = DangerWordModel(
      patientDocRef: authController.patientDocRef,
    );
  }
}