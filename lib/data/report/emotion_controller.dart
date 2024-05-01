import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class EmotionModel {
  DocumentReference? patientDocRef;
  List<String>? emotionsList;
  Timestamp? createdAt;
  DocumentReference? reference; // document 식별자

  EmotionModel({
    this.patientDocRef,
    this.emotionsList,
    this.createdAt,
    this.reference
  });

  EmotionModel.fromJson(dynamic json, this.reference) {
    patientDocRef = json['patientDocRef'];
    emotionsList = json['emotionsList'] != null
        ? List<String>.from(json['emotionsList'])
        : [];
    createdAt = json['createdAt'];
    reference = json['reference'];
  }

  EmotionModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  EmotionModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['patientDocRef'] = patientDocRef;
    map['emotionsList'] = emotionsList;
    map['createdAt'] = createdAt;
    map['reference'] = reference;
    return map;
  }
}


class EmotionService {
  final AuthController authController = Get.put(AuthController());
  final firestore = FirebaseFirestore.instance;

  Future<void> addEmotion(EmotionModel emotion) async {
    // 현재 주의 시작 및 끝 날짜 계산 (월요일부터 일요일까지의 날짜)
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = monday.add(Duration(days: 6));

    // 해당 주의 시작 및 끝을 Timestamp로 변환
    Timestamp startOfWeek = Timestamp.fromDate(monday);
    Timestamp endOfWeek = Timestamp.fromDate(sunday);

    // Firestore 컬렉션 레퍼런스
    CollectionReference weeklyEmotionCollection = firestore.collection('weekly_emotion');

    // 해당 주의 도큐먼트 쿼리
    QuerySnapshot querySnapshot = await weeklyEmotionCollection
        .where('patientDocRef', isEqualTo: authController.patientDocRef)
        .where('createdAt', isGreaterThanOrEqualTo: startOfWeek)
        .where('createdAt', isLessThanOrEqualTo: endOfWeek)
        .get();

    // 해당 주의 도큐먼트가 이미 존재하는지 확인
    if (querySnapshot.docs.isNotEmpty) {
      // 해당 주의 도큐먼트가 존재하는 경우, 업데이트
      DocumentReference docRef = querySnapshot.docs.first.reference;
      List<String> currentEmotionsList = List<String>.from(querySnapshot.docs.first.get('emotionsList'));

      currentEmotionsList.addAll(emotion.emotionsList!);

      await docRef.update({'emotionsList': currentEmotionsList});
    } else {
      // 해당 주의 도큐먼트가 존재하지 않는 경우, 생성
      DocumentReference docRef = await weeklyEmotionCollection.add({
        'createdAt': Timestamp.now(),
        'emotionsList': emotion.emotionsList,
        'patientDocRef': authController.patientDocRef
      });
      emotion.reference = docRef;
      await docRef.update(emotion.toJson());
    }
  }

}


class EmotionController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final EmotionService emotionService = EmotionService();
  var emotion = EmotionModel().obs();
  var documentReference;

  void addEmotion(List<String> emotionsList) async {
    try {
      EmotionModel emotionModel = EmotionModel(
          emotionsList: emotionsList,
          patientDocRef: authController.patientDocRef,
          createdAt: Timestamp.now()
      );
      await emotionService.addEmotion(emotionModel);
      clear();
    } catch (e) {
      print('Error adding emotion: $e');
    }
  }
  void clear() {
    emotion = EmotionModel(
      patientDocRef: authController.patientDocRef,
    );
  }

}
