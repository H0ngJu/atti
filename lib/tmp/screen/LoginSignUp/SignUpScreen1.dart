import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/tmp/screen/LogInSignUp/SignUpScreen2.dart';
import 'package:atti/tmp/screen/LoginSignUp/NextBtn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpScreen1 extends StatefulWidget {
  SignUpScreen1({super.key});

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  ColorPallet _colorPallet = ColorPallet();
  bool _isButtonDisabled = true;
  final SignUpController signUpController = Get.put(SignUpController());
  int isPressed = 0;
  void topBtnPressed() {
    setState(() {
      isPressed == 1 ? isPressed = 0 : isPressed = 1;
      isPressed == 1 ? _isButtonDisabled = false : _isButtonDisabled = true;
    });
  }
  void botBtnPressed() {
    setState(() {
      isPressed == 2 ? isPressed = 0 : isPressed = 2;
      isPressed == 2 ? _isButtonDisabled = false : _isButtonDisabled = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            DetailPageTitle(
              title: '회원가입',
              description: '',
              totalStep: 3,
              currentStep: 1,
            ),
            Container(
              margin: EdgeInsets.only(top: height*0.13),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 안내문
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Text(
                          '서비스를 이용할\n회원을 선택해주세요.',
                          style: TextStyle(
                            letterSpacing: 0.01,
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '서비스 이용이 구분되니 신중히 선택해주세요.',
                    style: TextStyle(
                      color: _colorPallet.grey,
                      fontSize: 20,
                      letterSpacing: 0.01,
                      fontFamily: 'PretendardRegular',
                    ),
                  ),
                  SizedBox(height : height*0.03,),
                  // 보호자 피보호자 선택 버튼
                  Container(
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {
                                topBtnPressed();
                                signUpController.isPatient.value = true;
                              },
                            style: TextButton.styleFrom(
                              backgroundColor: _colorPallet.lightYellow,
                              padding: EdgeInsets.zero,
                              side: BorderSide(
                                  width: 1,
                                  color: isPressed == 1 ? _colorPallet.orange : _colorPallet.lightYellow // isPressed 값에 따라 테두리 색상 결정
                              ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Container(
                            width: width * 0.4,
                            height: height * 0.3,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "피보호자",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'PretendardBold',
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(
                                    "치매 환자\n본인입니다.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'PretendardRegular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              botBtnPressed();
                              signUpController.isPatient.value = false;
                            },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFFFE0CC),
                            padding: EdgeInsets.zero,
                            side: BorderSide(
                                width: 1,
                                color: isPressed == 2 ? _colorPallet.orange : Color(0xFFFFE0CC),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Container(
                            width: width * 0.4,
                            height: height * 0.3,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "보호자",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'PretendardBold',
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(
                                    "치매 환자의\n보호자입니다.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'PretendardRegular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  NextBtn(isButtonDisabled: _isButtonDisabled, nextPage: SignUpScreen2())
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
