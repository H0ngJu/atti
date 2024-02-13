import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/SignUpController.dart';
import 'package:atti/screen/LoginSignUp/LogInSignUpMainScreen.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpScreen1 extends StatefulWidget {
  SignUpScreen1({super.key});

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  final SignUpController signUpController = Get.put(SignUpController());
  Color borderColor = const Color(0xffFFF5DB);
  Color pressedBorderColor = const Color(0xffFFC215);
  int isPressed = 0;
  void topBtnPressed() {
    setState(() {
      isPressed == 1 ? isPressed = 0 : isPressed = 1;
    });
  }
  void botBtnPressed() {
    setState(() {
      isPressed == 2 ? isPressed = 0 : isPressed = 2;
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
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      children: [
                        Text(
                          '회원선택',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '서비스 이용이 구분되니 신중히 선택해주세요',
                    style: TextStyle(
                      color: Color(0xff7E7E7E),
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: height*0.02,),
                  Container(
                    child: Column(
                      children: [
                        ElevatedButton(onPressed: (){
                          topBtnPressed();
                          signUpController.isPatient.value = true;
                        },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide(width: 2, color: isPressed == 1 ? pressedBorderColor : borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Container(
                              width: 350,
                              height: height*0.27,
                              decoration: BoxDecoration(
                                color: Color(0xffFFF5DB),
                                image: DecorationImage(
                                  image: AssetImage('lib/assets/images/membershipType_patient_bg.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '피보호자',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: isPressed == 1 ? Colors.black : Color(0xffA38130),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '치매 증상을 지니셨나요?',
                                      style: TextStyle(
                                        color: isPressed == 1 ? Colors.black : Color(0xffA38130),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: (){
                          botBtnPressed();
                          signUpController.isPatient.value = false;
                        },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: BorderSide(width: 2, color: isPressed == 2 ? pressedBorderColor : borderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Container(
                              width: 350,
                              height: height*0.27,
                              decoration: BoxDecoration(
                                color: Color(0xffFFF5DB),
                                image: DecorationImage(
                                  image: AssetImage('lib/assets/images/membershipType_carer_bg.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '보호자',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: isPressed == 2 ? Colors.black : Color(0xffA38130),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '치매 환자의 보호자이신가요?',
                                      style: TextStyle(
                                        color: isPressed == 2 ? Colors.black : Color(0xffA38130),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10,),
                        Visibility(
                            visible: isPressed != 0,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return SignUpScreen2();
                                      }
                                      )
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffFFF5DB),
                                ),
                                child: Container(
                                  width: 300,
                                  height: height*0.07,
                                  alignment: Alignment.center,
                                  child: Text('다음',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Color(0xffA38130),
                                    ),
                                  ),
                                )
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}