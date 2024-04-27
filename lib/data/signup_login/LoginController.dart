// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class LoginController extends GetxController {
//   FirebaseAuth _authentication = FirebaseAuth.instance;
//   FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // 로그인 시 사용하는 데이터
//   RxInt isPressed = 0.obs;
//
//   // 유저 공통 데이터
//   var userPassword = "".obs;
//   var  userEmail = "".obs;
//
//   void login() async {
//
//     print(userEmail.value);
//     print(userPassword.value);
//     try {
//
//       }
//     } catch (e) {
//       // 회원가입 실패 시 에러 메시지 출력
//       print("로그인 실패: $e");
//       // 실패 메시지를 사용자에게 표시하는 로직을 여기에 추가하세요. 예를 들어 Flutter에서는:
//       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("회원가입 실패: $e")));
//     }
//   }
// }
