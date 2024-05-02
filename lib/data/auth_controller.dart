import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  String? loggedUser = FirebaseAuth.instance.currentUser?.uid;
  bool isPatient = true;
  var userName = ''.obs;
  RxList<String> familyMember = <String>[].obs;
  late DocumentReference patientDocRef;

  @override
  void onInit() {
    super.onInit();
    init();
  }
  void init() async {
    try {
      // 비동기 방식으로 문서 가져오기
      var userSnapshot = await FirebaseFirestore.instance.collection('user')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      // 첫 번째 문서의 DocumentReference 가져오기
      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;
        isPatient = userDoc['isPatient'];
        userName.value = userDoc['userName'];
        // 환자일 경우 : patientDocRef는 본인의 reference, familymember 초기화 필요
        if (isPatient) {
          familyMember.value = List<String>.from(userDoc['familyMember']);
          patientDocRef = userDoc.reference;
        }
        // 보호자일 경우 : patientDocRef는 db.doc(user/ + patientDocId)
        else {
          patientDocRef = FirebaseFirestore.instance.doc('user/'+userDoc['patientDocId']);
        }
      } else {
        print("No documents found");
      }
    } catch (e) {
      print("auth Error : ${e.toString()}");
    }
  }
}


// class AuthController extends GetxController {
//   String loggedUser = FirebaseAuth.instance.currentUser!.uid;
//   bool isPatient = true;
//   var userName = ''.obs;
//   RxList<String> familyMember = <String>[].obs;
//   late DocumentReference patientDocRef;
// }

// class AuthController extends GetxController {
//   final authentication = FirebaseAuth.instance;
//   final firestore = FirebaseFirestore.instance;
//
//   late Rx<User?> loggedUser; // 현재 로그인한 사용자
//   late RxBool isPatient;
//   late RxString userName;
//   late RxList<String> familyMember;
//   late RxString patientDocRef; // 사용자와 연결된 환자의 도큐먼트 레퍼런스
//   late Rx<DocumentReference?> userDocRef; // 사용자의 도큐먼트 레퍼런스
//
//   @override
//   void onInit() {
//     loggedUser = Rx<User?>(authentication.currentUser);
//     isPatient = true.obs;
//     userName = "".obs;
//     familyMember = <String>[].obs;
//     patientDocRef = "".obs;
//     userDocRef = Rx<DocumentReference?>(null);
//
//     super.onInit();
//
//     getCurrentUser();
//   }
//
//   // 현재 사용자 정보 가져오기
//   Future<void> getCurrentUser() async {
//     try {
//       final user = loggedUser.value;
//       print("loggedUser: ${user!.uid}");
//       if (user != null) {
//         // 사용자의 도큐먼트 레퍼런스 가져오기
//         userDocRef.value = firestore.collection('user').doc(user.uid);
//
//         // 사용자 정보 설정
//         DocumentSnapshot userSnapshot = await userDocRef.value!.get();
//         isPatient.value = userSnapshot['isPatient'];
//         userName.value = userSnapshot['userName'];
//       };
//     } catch (e) {
//       print("Error getting uid : $e");
//     }
//   }
//
//   // 현재 사용자의 uid와 userID 필드가 일치하는 사용자 도큐먼트의 레퍼런스 리턴
//   // -> 사용자의 환자/보호자 여부와 이름 저장
//   // Future<DocumentReference?> getUserDocumentReference(String userId) async {
//   //   try {
//   //     QuerySnapshot querySnapshot = await firestore.collection('user')
//   //         .where('userId', isEqualTo: userId)
//   //         .get();
//   //
//   //     if (querySnapshot.docs.isNotEmpty) {
//   //       DocumentSnapshot userDocument = querySnapshot.docs.first;
//   //       isPatient.value = userDocument['isPatient'];
//   //       userName.value = userDocument['userName'];
//   //       return userDocument.reference;
//   //     } else return null;
//   //   } catch (e) {
//   //     print("Error getting user document reference: $e");
//   //     return null;
//   //   }
//   // }
//
//   // 사용자와 연결된 환자의 도큐먼트 레퍼런스 가져오기
//   // -> 환자의 가족 구성원 저장
//   Future<void> getPatientDocumentReference() async {
//     try {
//       if (isPatient.value) { // 환자인 경우
//         patientDocRef.value = userDocRef.value!.id;
//
//         DocumentSnapshot patientDocument = await userDocRef.value!.get();
//         familyMember.value = List<String>.from(patientDocument['familyMember']);
//       }
//       else { // 보호자인 경우
//         QuerySnapshot querySnapshot = await firestore.collection('user')
//             .where('userId', isEqualTo: loggedUser.value!.uid)
//             .get();
//
//         if (querySnapshot.docs.isNotEmpty) {
//           DocumentSnapshot userDocument = querySnapshot.docs.first;
//           String? patientUid = userDocument['patientUid'];
//
//           QuerySnapshot patientQuerySnapshot = await firestore.collection('user')
//               .where('userId', isEqualTo: patientUid)
//               .get();
//
//           if (patientQuerySnapshot.docs.isNotEmpty) {
//             DocumentSnapshot patientDocument = patientQuerySnapshot.docs.first;
//             patientDocRef.value = patientDocument.reference.id;
//             familyMember.value = List<String>.from(patientDocument['familyMember']);
//           }
//         }
//       }
//     } catch (e) {
//       print("Error getting patient document reference: $e");
//     }
//   }
//
// }
