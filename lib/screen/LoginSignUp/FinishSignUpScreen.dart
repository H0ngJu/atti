import 'package:atti/commons/colorPallet.dart';
import 'package:atti/screen/LogInSignUp/LogInScreen.dart';
import 'package:atti/screen/LoginSignUp/NextBtn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinishSignUpScreen extends StatefulWidget {
  const FinishSignUpScreen({super.key});

  @override
  State<FinishSignUpScreen> createState() => _FinishSignUpScreenState();
}

class _FinishSignUpScreenState extends State<FinishSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ColorPallet colorPallet = Get.put(ColorPallet());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('lib/assets/images/FinishSignUpImage.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: height*0.1, left: 20),
            child: Text(
              '회원가입이\n완료되었어요!',
              style: TextStyle(
                letterSpacing: 0.1,
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'PretendardBold',
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: height*0.85, left: 10, right: 10),
            child: TextButton(
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context)=>LogInScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: width*0.02),
                    width: width*0.9,
                    height: height*0.06,
                    alignment: Alignment.center,
                    child: Text('로그인',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'PretendardBold',
                        )
                    )
                )
            ),
          ),
        ],
      ),
    );
  }
}
