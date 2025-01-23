import 'package:atti/data/auth_controller.dart';
import 'package:atti/login_signUp/LogInSignUpMainScreen.dart';
import 'package:atti/tmp/screen/HomeCarer.dart';
import 'package:atti/patient/screen/HomePatient.dart';
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
    AuthController authController = Get.put(AuthController());
    authController.init();
    Future.delayed(Duration(seconds: 2), () {
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
