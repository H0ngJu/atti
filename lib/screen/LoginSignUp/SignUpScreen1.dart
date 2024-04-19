import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/SignUpController.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen2.dart';
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
      _isButtonDisabled = false;
    });
  }
  void botBtnPressed() {
    setState(() {
      isPressed == 2 ? isPressed = 0 : isPressed = 2;
      _isButtonDisabled = false;
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
                        TextButton(
                          onPressed: (){
                          topBtnPressed();
                          signUpController.isPatient.value = true;
                        },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide(
                                  width: 1,
                                  color: isPressed == 1 ? _colorPallet.textColor : Colors.black
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Container(
                              width: width*0.4,
                              height: height*0.3,
                              child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '피보호자',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: height*0.01,),
                                      Text(
                                        '치매 증상을\n지니셨나요?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        SizedBox(
                          width: width*0.05,
                        ),
                        TextButton(
                          onPressed: (){
                            botBtnPressed();
                            signUpController.isPatient.value = false;
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: BorderSide(
                                width: 1,
                                color: isPressed == 2 ? _colorPallet.textColor : Colors.black
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Container(
                            width: width*0.4,
                            height: height*0.3,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '보호자',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: height*0.01,),
                                  Text(
                                    '치매 환자의\n보호자이신가요?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: height*0.3),
                      width: width*0.9,
                      height: height*0.07,
                      child: TextButton(
                        onPressed: _isButtonDisabled ? null : () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return SignUpScreen2();
                              }
                              )
                          );
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: _isButtonDisabled ? Colors.white : _colorPallet.goldYellow,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: _colorPallet.goldYellow,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                        child: Text('다음',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: _isButtonDisabled
                                ?_colorPallet.textColor
                                : Colors.white,
                          ),
                        ),
                      )
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
