// // 저장된 기록
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RegisteredMemoryModel {
//   // 자료형
//   String? patientId;
//   Timestamp? createdAt;
//   // Timestamp? date;
//   String? memoryDocId;
//   int? registeredNumber;
//   DocumentReference? reference; // document 식별자
//
//   // 생성자
//   RegisteredMemoryModel({
//     this.patientId,
//     this.createdAt,
//     // this.date,
//     this.memoryDocId,
//     this.registeredNumber,
//     this.reference
//   });
//
//   // json -> object (Firestore -> Flutter)
//   RegisteredMemoryModel.fromJson(dynamic json, this.reference) {
//     patientId = json['patientId'];
//     createdAt = json['createdAt'];
//     memoryDocId = json['memoryDocId'];
//     registeredNumber = json['registeredNumber'];
//     reference = json['reference'];
//   }
//
//   // Named Constructor with Initializer
//   RegisteredMemoryModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.reference);
//
//   // Named Constructor with Initializer
//   RegisteredMemoryModel.fromQuerySnapshot(
//       QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data(), snapshot.reference);
//
//   // object -> json (Flutter -> Firebase)
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['patientId'] = patientId;
//     map['createdAt'] = createdAt;
//     map['memoryDocId'] = memoryDocId;
//     map['registeredNumber'] = registeredNumber;
//     map['reference'] = reference;
//     return map;
//   }
// }
//
// class UnfinishedRoutineController extends GetxController {
//   final RegisteredMemoryService registeredMemoryService = RegisteredMemoryService();
//   var registeredMemory = RegisteredMemoryModel().obs;
//   var tmpName = ''.obs;
//
//   void addRegisteredMemory() async {
//     try {
//       await registeredMemoryService.addRegisteredMemory(registeredMemory.value);
//       clear();
//     } catch (e) {
//       print('Error adding registeredMemory: $e');
//     }
//   }
//
//   void clear() {
//     registeredMemory.value = RegisteredMemoryModel();
//   }
//
// }
//
// class RegisteredMemoryService {
//   final firestore = FirebaseFirestore.instance;
//
//   Future<void> addRegisteredMemory(RegisteredMemoryModel registeredMemory) async {
//     try {
//       registeredMemory.createdAt = Timestamp.now();
//       DocumentReference docRef = await firestore.collection('registeredMemory').add(registeredMemory.toJson());
//       registeredMemory.reference = docRef;
//       await docRef.update(registeredMemory.toJson());
//     } catch (e) {
//       print('Error adding registeredMemory: $e');
//     }
//   }
// }