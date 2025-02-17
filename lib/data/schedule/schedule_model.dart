import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  // 자료형
  String? name;
  String? location = ""; // 기본값 추가
  String? memo;
  DocumentReference? patientId;
  Timestamp? createdAt;
  Timestamp? time;
  bool? isFinished;
  DocumentReference? reference; // document 식별자
  bool? isPatient;
  bool? notified;
  bool? notifiedOneHour;

  // 생성자
  ScheduleModel({
    this.name,
    this.location,
    this.memo,
    this.patientId,
    this.createdAt,
    this.time,
    this.isFinished = false,
    this.reference,
    this.isPatient,
    this.notified = false,
    this.notifiedOneHour = false
  });

  // json -> object (Firestore -> Flutter)
  ScheduleModel.fromJson(dynamic json, this.reference) {
    name = json['name'];
    location = json['location'];
    memo = json['memo'];
    patientId = json['patientId'];
    createdAt = json['createdAt'];
    time = json['time'];
    isFinished = json['isFinished'];
    reference = json['reference'];
    isPatient = json['isPatient'];
    notified = json['notified'];
    notifiedOneHour = json['notifiedOneHour'];
  }

  // Named Constructor with Initializer
  ScheduleModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.reference);

  // Named Constructor with Initializer
  ScheduleModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  // object -> json (Flutter -> Firebase)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['location'] = location;
    map['memo'] = memo;
    map['patientId'] = patientId;
    map['createdAt'] = createdAt;
    map['time'] = time;
    map['isFinished'] = isFinished;
    map['reference'] = reference;
    map['isPatient'] = isPatient;
    map['notified'] = notified;
    map['notifiedOneHour'] = notifiedOneHour;
    return map;
  }
}
