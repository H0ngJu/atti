// // 감정 키워드
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EmotionKeywordModel {
//   // 자료형
//   String? patientId;
//   Timestamp? createdAt;
//   // Timestamp? date;
//   String? memoryDocId;
//   List<String>? emotionKeyword;
//   DocumentReference? reference; // document 식별자
//
//   // 생성자
//   EmotionKeywordModel({
//     this.patientId,
//     this.createdAt,
//     // this.date,
//     this.memoryDocId,
//     this.emotionKeyword,
//     this.reference
//   });
//
//   // json -> object (Firestore -> Flutter)
//   EmotionKeywordModel.fromJson(dynamic json, this.reference) {
//     patientId = json['patientId'];
//     createdAt = json['createdAt'];
//     memoryDocId = json['memoryDocId'];
//     emotionKeyword = json['emotionKeyword'];
//     reference = json['reference'];
//   }
//
//   // Named Constructor with Initializer
//   EmotionKeywordModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.reference);
//
//   // Named Constructor with Initializer
//   EmotionKeywordModel.fromQuerySnapshot(
//       QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
//       : this.fromJson(snapshot.data()!, snapshot.reference);
//
//   // object -> json (Flutter -> Firebase)
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['patientId'] = patientId;
//     map['createdAt'] = createdAt;
//     map['memoryDocId'] = memoryDocId;
//     map['emotionKeyword'] = emotionKeyword;
//     map['reference'] = reference;
//     return map;
//   }
// }
//
// class EmotionKeywordController extends GetxController {
//   final EmotionKeywordService emotionKeywordService = EmotionKeywordService();
//   var emotionKeyword = EmotionKeywordModel().obs;
//   var tmpName = ''.obs;
//
//   void addEmotionKeyword() async {
//     try {
//       await emotionKeywordService.addEmotionKeyword(emotionKeyword.value);
//       clear();
//     } catch (e) {
//       print('Error adding emotionKeyword: $e');
//     }
//   }
//
//   void clear() {
//     emotionKeyword.value = EmotionKeywordModel();
//   }
//
// }
//
// class EmotionKeywordService {
//   final firestore = FirebaseFirestore.instance;
//
//   Future<void> addEmotionKeyword(EmotionKeywordModel emotionKeyword) async {
//     try {
//       emotionKeyword.createdAt = Timestamp.now();
//       DocumentReference docRef = await firestore.collection('emotionKeyword').add(emotionKeyword.toJson());
//       emotionKeyword.reference = docRef;
//       await docRef.update(emotionKeyword.toJson());
//     } catch (e) {
//       print('Error adding emotionKeyword: $e');
//     }
//   }
// }