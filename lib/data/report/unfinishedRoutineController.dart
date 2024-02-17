// // 미완료 루틴
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UnfinishedRoutineModel {
//   // 자료형
//   String? patientId;
//   Timestamp? createdAt;
//   // Timestamp? date;
//   String? unfinishedRoutineDocId;
//   DocumentReference? reference; // document 식별자
//
//   // 생성자
//   UnfinishedRoutineModel({
//     this.patientId,
//     this.createdAt,
//     // this.date,
//     this.unfinishedRoutineDocId,
//     this.reference
//   });
//
//   // json -> object (Firestore -> Flutter)
//   UnfinishedRoutineModel.fromJson(dynamic json, this.reference) {
//     patientId = json['patientId'];
//     createdAt = json['createdAt'];
//     // date = json['date'];
//     unfinishedRoutineDocId = json['unfinishedRoutineDocId'];
//     reference = json['reference'];
//   }
//
//   // Named Constructor with Initializer
//   UnfinishedRoutineModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.reference);
//
//   // Named Constructor with Initializer
//   UnfinishedRoutineModel.fromQuerySnapshot(
//       QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data(), snapshot.reference);
//
//   // object -> json (Flutter -> Firebase)
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['patientId'] = patientId;
//     map['createdAt'] = createdAt;
//     // map['date'] = date;
//     map['unfinishedRoutineDocId'] = unfinishedRoutineDocId;
//     map['reference'] = reference;
//     return map;
//   }
// }
//
// class UnfinishedRoutineController extends GetxController {
//   final UnfinishedRoutineService unfinishedRoutineService = UnfinishedRoutineService();
//   var unfinishedRoutine = UnfinishedRoutineModel().obs;
//   var tmpName = ''.obs;
//
//   void addUnfinishedRoutine() async {
//     try {
//       await unfinishedRoutineService.addUnfinishedRoutine(unfinishedRoutine.value);
//       clear();
//     } catch (e) {
//       print('Error adding unfinishedRoutine: $e');
//     }
//   }
//
//   void clear() {
//     unfinishedRoutine.value = UnfinishedRoutineModel();
//   }
//
// }
//
// class UnfinishedRoutineService {
//   final firestore = FirebaseFirestore.instance;
//
//   Future<void> addUnfinishedRoutine(UnfinishedRoutineModel unfinishedRoutine) async {
//     try {
//       unfinishedRoutine.createdAt = Timestamp.now();
//       DocumentReference docRef = await firestore.collection('unfinishedRoutine').add(unfinishedRoutine.toJson());
//       unfinishedRoutine.reference = docRef;
//       await docRef.update(unfinishedRoutine.toJson());
//     } catch (e) {
//       print('Error adding unfinishedRoutine: $e');
//     }
//   }
// }