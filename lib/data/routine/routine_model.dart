import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineModel {
  // 자료형
  String? name;
  String? patientId;
  String? img;
  List<int>? time;
  Timestamp? createdAt;
  List<String>? repeatDays;
  List<String>? isFinished;
  DocumentReference? reference; // document 식별자

  // 생성자
  RoutineModel({
    this.name,
    this.patientId,
    this.img,
    this.time,
    this.createdAt,
    this.repeatDays,
    this.reference,
  }) : isFinished = []; // 기본값으로 빈 리스트를 할당

  // json -> object (Firestore -> Flutter)
  RoutineModel.fromJson(dynamic json, this.reference) {
    name = json['name'];
    patientId = json['patientId'];
    img = json['img'];
    time = List<int>.from(json['time']);
    createdAt = json['createdAt'];
    repeatDays = List<String>.from(json['repeatDays']);

    // isFinished 필드가 Null일 경우 빈 리스트로 초기화
    isFinished = (json['isFinished'] != null) ? List<String>.from(json['isFinished']) : [];
  }

  // Named Constructor with Initializer
  RoutineModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // Named Constructor with Initializer
  RoutineModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['patientId'] = patientId;
    map['img'] = img;
    map['time'] = time;
    map['createdAt'] = createdAt;
    map['repeatDays'] = repeatDays;
    map['isFinished'] = isFinished;
    map['reference'] = reference;
    return map;
  }
}