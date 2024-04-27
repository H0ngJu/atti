import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/SignUpController.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen2.dart';
import 'package:atti/screen/LoginSignUp/CustomerTypeBtn.dart';
import 'package:atti/screen/LoginSignUp/NextBtn.dart';
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
                          '회원 선택',
                          style: TextStyle(
                            letterSpacing: 0.01,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '서비스 이용이 구분되니 신중히 선택해주세요.',
                    style: TextStyle(
                      color: _colorPallet.grayColor,
                      fontSize: 20,
                      letterSpacing: 0.01,
                    ),
                  ),
                  SizedBox(height : height*0.03,),
                  // 보호자 피보호자 선택 버튼
                  Container(
                    child: Row(
                      children: [
                        CustomerTypeBtn(
                            onPressed: () {
                              topBtnPressed();
                              signUpController.isPatient.value = true;
                              },
                            isPressed: isPressed,
                            buttonId: 1,
                            mainText: '피보호자',
                            detailText: '치매 증상을\n지니셨나요?'),
                        SizedBox(
                          width: width*0.05,
                        ),
                        CustomerTypeBtn(
                            onPressed: (){
                              botBtnPressed();
                              signUpController.isPatient.value = false;
                              },
                            isPressed: isPressed,
                            buttonId: 2,
                            mainText: "보호자",
                            detailText: "치매 환자의\n보호자이신가요?"),
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
