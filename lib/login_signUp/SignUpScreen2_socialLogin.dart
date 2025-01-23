import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/tmp/screen/LogInSignUp/SignUpScreen3.dart';
import 'package:atti/tmp/screen/LoginSignUp/NextBtn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen2_socialLogin extends StatefulWidget {
  SignUpScreen2_socialLogin({super.key});

  @override
  State<SignUpScreen2_socialLogin> createState() => _SignUpScreen2_socialLoginState();
}

class _SignUpScreen2_socialLoginState extends State<SignUpScreen2_socialLogin> {
  final SignUpController _signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          _signUpController.isPressed.value = 0;
        },
        child: Stack(
          children: [
            DetailPageTitle(
              title: '회원가입',
              description: '',
              totalStep: 3,
              currentStep: 2,
            ),
            Container(
              margin: EdgeInsets.only(top: height*0.2),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width*0.1, vertical: width*0.15),
                        child: Text(
                          "간편하게 로그인하고\n다양한 서비스를 이용해 보세요",
                          style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 0.01,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: null,
                          child: Image.asset('lib/assets/images/kakao_login.png'),
                      ),
                      NextBtn(isButtonDisabled: false, nextPage: SignUpScreen3()),
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
