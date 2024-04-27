import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
      QuerySnapshot snapshot = await _db
          .collection('user')
          .where('userId', isEqualTo: credential.user!.uid)
          .get();
      DocumentSnapshot document = snapshot.docs[0];
      isPatient = await (document.data() as Map<String, dynamic>)["isPatient"];
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error : ${e}");
      Get.snackbar(
        '로그인 실패', // 제목
        '아이디 또는 비밀번호가 일치하지 않습니다', // 메시지
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xffFFC215),
        colorText: Colors.black,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        snackStyle: SnackStyle.FLOATING,
        duration: Duration(seconds: 4),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return false;
    }
  }
}
