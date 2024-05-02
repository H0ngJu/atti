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