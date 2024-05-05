import 'package:atti/data/report/reportController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  String? loggedUser = FirebaseAuth.instance.currentUser?.uid;
  bool isPatient = true;
  var userName = ''.obs;
  var userEmail = ''.obs;
  RxList<String> familyMember = <String>[].obs;
  DocumentReference? patientDocRef;
  RxString patientName = "".obs;
  var carerReports; // = ReportController().getReport();

  @override
  void onInit() {
    super.onInit();
    init();
  }
  void init() async {
    try {
      loggedUser = FirebaseAuth.instance.currentUser?.uid;
      // 비동기 방식으로 문서 가져오기
      var userSnapshot = await FirebaseFirestore.instance.collection('user')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      // 첫 번째 문서의 DocumentReference 가져오기
      if (userSnapshot.docs.isNotEmpty) {
        var userDoc = userSnapshot.docs.first;
        isPatient = userDoc['isPatient'];
        userName.value = userDoc['userName'];
        userEmail.value = userDoc['userEmail'];
        // 환자일 경우 : patientDocRef는 본인의 reference, familymember 초기화 필요
        if (isPatient) {
          familyMember.value = List<String>.from(userDoc['familyMember']);
          patientDocRef = userDoc.reference;
        }
        // 보호자일 경우 : patientDocRef는 db.doc(user/ + patientDocId)
        else {
          patientDocRef = await FirebaseFirestore.instance.doc('user/'+userDoc['patientDocId']);
          // 문서에서 데이터를 비동기적으로 가져옴
          await patientDocRef!.get().then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              // 'userName' 키를 이용해 사용자 이름 가져옴
              patientName.value = documentSnapshot['userName'];
            } else {
              print("Document does not exist.");
            }
          }).catchError((error) {
            // 에러 처리
            print("Error getting document: $error");
          });
          // 보호자일 경우에만 carerReports 호출
          carerReports = ReportController().getReport();
          print("carerReports 성공! : ${carerReports[0]}");
        }
      } else {
        print("No documents found");
      }
      update();
    } catch (e) {
      print("auth Error : ${e.toString()}");
    }
  }

  void logout() async {
    try {
      loggedUser = null;
      isPatient = true;
      userName.value = '';
      userEmail.value = '';
      familyMember.clear();
      patientDocRef = null;
      patientName.value = "";
      carerReports = null;
      print("로그아웃 성공!");
      // 상태 업데이트
      update();
    } catch (e) {
      print("Error logging out: ${e.toString()}");
    }
  }
}

