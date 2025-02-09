import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoUpdateController extends GetxController {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 사용자 정보
  var userName = "".obs;
  var userFamily = <String>[].obs;
  // DateTime? userBirthDate;

  Future<void> fetchUserInfo() async {
    try {
      User? user = _authentication.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await _db
            .collection('user')
            .where('userId', isEqualTo: user.uid) // userId가 user.uid와 같은 문서 찾기
            .get();

        if (querySnapshot.docs.isNotEmpty) { // 문서가 존재하는 경우
          DocumentSnapshot doc = querySnapshot.docs.first; // 첫 번째 문서 가져오기
          print("data ${doc.data()}");
          userName.value = doc['userName'] ?? ""; // 기본값 설정
          userFamily.value = List<String>.from(doc['familyMember'] ?? []);
          // userBirthDate = (doc['birthDate'] as Timestamp).toDate();
        } else {
          print("문서가 존재하지 않습니다."); // 문서가 없는 경우
          userName.value = "";
          userFamily.value = [];
          // userBirthDate = null; // 기본값 설정
        }
      }
    } catch (e) {
      print("사용자 정보 가져오기 실패 - init: $e");
    }
  }

  // 사용자 정보를 업데이트하는 메서드
  Future<void> updateUserInfo() async {
    try {
      User? user = _authentication.currentUser;
      if (user != null) {
        // 업데이트할 사용자 정보
        Map<String, dynamic> updatedInfo = {
          "userName": userName.value,
          "familyMember": userFamily.value,
          // "birthDate": userBirthDate != null ? Timestamp.fromDate(userBirthDate!) : null,
        };

        // Firestore에서 userId가 user.uid인 문서 업데이트
        QuerySnapshot querySnapshot = await _db
            .collection('user')
            .where('userId', isEqualTo: user.uid) // userId가 user.uid와 같은 문서 찾기
            .get();

        if (querySnapshot.docs.isNotEmpty) { // 문서가 존재하는 경우
          DocumentSnapshot doc = querySnapshot.docs.first; // 첫 번째 문서 가져오기
          await doc.reference.update(updatedInfo); // 해당 문서 업데이트
          print("사용자 정보가 성공적으로 업데이트되었습니다.");
        } else {
          print("업데이트할 문서가 존재하지 않습니다."); // 문서가 없는 경우
        }
      }
    } catch (e) {
      print("사용자 정보 업데이트 실패 - update: $e");
    }
  }

}
