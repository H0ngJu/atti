import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 가입 시 사용하는 데이터
  RxInt isPressed = 0.obs;
  var userEmail = "".obs;
  var userPatientEmail = "".obs; // 피보호자의 보호자 식별 목적

  // 유저 공통 데이터
  RxBool isPatient = true.obs;
  var userPassword = "".obs;
  var userPasswordCheck = "".obs;
  var userName = "".obs;
  var userPhoneNumber = "".obs;
  String? userFCMToken = "";
  var userSex = 0.obs;
  var scrn3_isValid = false.obs;
  var scrn4_isValid = false.obs;
  var scrn4_btnIsValid = false.obs;
  var scrn4_codeIsValid = false.obs;
  var authCode = "".obs;

  // 보호자 전용 데이터
  late DocumentReference patientDocId;

  // 피보호자 전용 데이터
  DateTime? userBirthDate;
  late RxList<String> userFamily = <String>[].obs;
  RxInt userAge = 0.obs;

  int calculateAge() {
    DateTime currentDate = DateTime.now();
    userAge.value = currentDate.year - userBirthDate!.year;

    if (currentDate.month < userBirthDate!.month ||
        (currentDate.month == userBirthDate!.month && currentDate.day < userBirthDate!.day)) {
      userAge.value--;
    }
    return userAge.value;
  }

  void signUp() async {
    // 보호자
    if (!isPatient.value) {
      // 유저가 입력한 환자 계정이 존재하는지 확인
      QuerySnapshot snapshot = await _db
          .collection('user')
          .where('userEmail', isEqualTo: userPatientEmail.value)
          .where('isPatient', isEqualTo: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        patientDocId = snapshot.docs[0].reference;
      } else {
        print('일치하는 피보호자가 없습니다');
        throw Exception("일치하는 피보호자가 없습니다");
      }
    }
    print(userEmail.value);
    print(userPassword.value);

    // 현재 디바이스의 FCM 토큰 저장
    userFCMToken = await FirebaseMessaging.instance.getToken();

    try {
      // 회원가입
      final newUser = await _authentication
          .createUserWithEmailAndPassword(
          email: userEmail.value,
          password: userPassword.value);
      // 회원가입 성공 시
      if (newUser.user != null) {
        print("회원가입 성공! : ${newUser.user!.uid}");
        // 사용자 정보를 담을 userInfo Map 생성
        final Map<String, dynamic> userInfo;
        // 피보호자
        if (isPatient.value) {
          userInfo = {
            "userId": newUser.user!.uid, // auth의 유저 식별자
            "age": calculateAge(),
            "birthDate": userBirthDate,
            "createdAt": DateTime.now(),
            "familyMember": userFamily.value,
            "isPatient": isPatient.value,
            "phoneNumber": userPhoneNumber.value,
            "userName": userName.value,
            "userEmail": userEmail.value,
            "userFCMToken": userFCMToken
          };
        }
        // 보호자
        else {
          userInfo = {
            "userId": newUser.user!.uid, // auth의 유저 식별자
            "createdAt": DateTime.now(),
            "patientDocId": patientDocId.id,
            "isPatient": isPatient.value,
            "phoneNumber": userPhoneNumber.value,
            "userName": userName.value,
            "userEmail": userEmail.value,
            "userFCMToken": userFCMToken
          };

        }
        // 문서 레퍼런스 업데이트
        var docRef = await _db
            .collection("user")
            .add(userInfo);
        if (!isPatient.value) {
          await patientDocId.update({
            'carerRef': docRef
          });
        }
        await docRef.update({ "reference": docRef});
      }
    } catch (e) {
      // 회원가입 실패 시 에러 메시지 출력
      print("회원가입 실패: $e");
    }
  }
}
