import 'package:atti/screen/HomeCarer.dart';
import 'package:atti/screen/HomePatient.dart';
import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:atti/screen/RoutineScheduleMain.dart';
import 'package:atti/screen/memory/gallery/MainGallery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/auth_controller.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      print("loggedUser: ${user!.uid}");
      print("check: ${authController.patientName.value}");
      if (user != null) {
        loggedUser = user as User?;
      }
      ;
    } catch (e) {
      print(e);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      margin: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height * 0.07, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.asset(
              'lib/assets/AttiBlack.png',
              width: 150,
            ),
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.close,
                  color: Color(0xffB8B8B8),
                  size: 40,
                )),
          ]),
          SizedBox(
            height: 20,
          ),
          Text(
            '주요기능',
            style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 24,
                color: Color(0xff868686)),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
              onTap: () {
                authController.isPatient ? Get.to(HomePatient()) : Get.to(HomeCarer());
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xffFFF5DB),
                    borderRadius: BorderRadius.circular(15)),
                height: 100,
                child: Text(
                  '홈',
                  style:
                      TextStyle(fontSize: 40, fontFamily: 'PretendardRegular'),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Get.to(MainGallery());
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xffFFECBE),
                    borderRadius: BorderRadius.circular(15)),
                height: 100,
                child: Text(
                  '내 기억',
                  style:
                      TextStyle(fontSize: 40, fontFamily: 'PretendardRegular'),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Get.to(RoutineScheduleMain());
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color(0xffFFE199),
                    borderRadius: BorderRadius.circular(15)),
                height: 100,
                child: Text(
                  '일과 / 일정',
                  style:
                      TextStyle(fontSize: 40, fontFamily: 'PretendardRegular'),
                ),
              )),
          SizedBox(
            height: 40,
          ),
          Text(
            '계정',
            style: TextStyle(
                fontFamily: 'PretendardRegular',
                fontSize: 24,
                color: Color(0xff868686)),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xff868686))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('최한별', style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'PretendardRegular'),),
                    Text('아이디', style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'PretendardRegular')),
                  ],
                ),
                TextButton(
                    onPressed: () async {
                      try {
                        await _authentication.signOut();
                        Get.offAll(LogInSignUpMainScreen());
                      } catch (error) {
                        print("로그아웃 실패: $error");
                      }
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.black),
                    child: Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )
        ],
      ),
    )));
  }
}
