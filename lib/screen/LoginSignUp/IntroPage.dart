import 'package:atti/data/auth_controller.dart';
import 'package:atti/screen/HomeCarer.dart';
import 'package:atti/screen/HomePatient.dart';
import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.put(AuthController());
    Future.delayed(Duration(seconds: 2), () {
      print("로그인 상태 확인 후 페이지 이동 시도"); // debug
      if (authController.loggedUser != null) {
        // 로그인한 유저가 있는 경우
        Get.off(() => authController.isPatient ? HomePatient() : HomeCarer());
      } else {
        // 로그인한 유저가 없는 경우
        Get.off(() => LogInSignUpMainScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('로그인한 유저 : ${AuthController().loggedUser}'); // debug
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            'lib/assets/images/MainATTI.png',
            width: width * 0.6,
          ),
        ),
      ),
    );
  }
}
