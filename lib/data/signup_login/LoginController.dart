import 'package:atti/data/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _authController = Get.put(AuthController());


  // 로그인 시 사용하는 데이터
  RxInt isPressed = 0.obs;
  var userPassword = "".obs;
  var userEmail = "".obs;
  bool? isPatient;

  Future<bool> login() async {
    try {
      final credential = await _authentication.signInWithEmailAndPassword(
        email: userEmail.value,
        password: userPassword.value,
      );

      // FCM 토큰 가져오기
      String? userFCMToken = await FirebaseMessaging.instance.getToken();

      QuerySnapshot snapshot = await _db
          .collection('user')
          .where('userId', isEqualTo: credential.user!.uid)
          .get();
      DocumentSnapshot document = snapshot.docs[0];

      // 사용자 정보 업데이트
      await _db.collection('user').doc(document.id).update({
        'userFCMToken': userFCMToken,
      });

      isPatient = await (document.data() as Map<String, dynamic>)["isPatient"];
      // _authController.login();
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error : $e");
      Get.snackbar(
        '로그인 실패', // 제목
        '아이디 또는 비밀번호가 일치하지 않습니다', // 메시지
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xffFFC215),
        colorText: Colors.black,
        borderRadius: 20,
        margin: const EdgeInsets.all(15),
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }
}
