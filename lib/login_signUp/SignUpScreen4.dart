import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/login_signUp/SignUpScreen4.dart';
import 'package:atti/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:atti/commons/colorPallet.dart';

class SignUpScreen4 extends StatefulWidget {
  SignUpScreen4({super.key});

  @override
  State<SignUpScreen4> createState() => _SignUpScreen4State();
}

class _SignUpScreen4State extends State<SignUpScreen4> {
  final SignUpController _signUpController = Get.put(SignUpController());
  // final SignUpController _signUpController = Get.find<SignUpController>();
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _formKey = GlobalKey<FormState>();

  User? loggedUser;
  DateTime userBirthDate = DateTime.now();
  String formattedDate = "연도 / 월 / 일을 선택해 주세요";

  @override
  Widget build(BuildContext context) {

    ColorPallet _colorPallet = ColorPallet();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isValid = _signUpController.userName.value.length > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            DetailPageTitle(
              title: '본인인증',
              description: '',
              totalStep: 3,
              currentStep: 3,
            ),

            Container(
              margin: EdgeInsets.only(top: height * 0.2, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '휴대폰 번호를 입력해 주세요.',
                        style: TextStyle(
                          letterSpacing: 0.01,
                          fontSize: 24,
                          fontFamily: 'PretendardRegular',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height*0.01),
                        padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 7.0, left: 9.0),
                        decoration: BoxDecoration(
                          color: _colorPallet.lightYellow,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: _signUpController.isPressed.value == 1 ? _colorPallet.textColor : _colorPallet.lightYellow,
                          ),
                        ),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              _signUpController.isPressed.value = 1;
                            });
                            print("isPressed = ${ _signUpController.isPressed.value}\nfieldId = ${1}");
                          },
                          onChanged: (value) => _signUpController.userName.value = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "이름",
                            hintStyle: TextStyle(
                              fontSize: 24,
                              color: _colorPallet.textColor,
                              fontFamily: 'PretendardRegular',
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      NextBtn(
                        isButtonDisabled: !isValid,
                        nextPage: SignUpScreen4(),
                        buttonName: "확인",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}