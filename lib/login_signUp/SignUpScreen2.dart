import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/tmp/screen/LogInSignUp/SignUpScreen3.dart';
import 'package:atti/tmp/screen/LoginSignUp/EntryField.dart';
import 'package:atti/tmp/screen/LoginSignUp/NextBtn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen2 extends StatefulWidget {
  SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final SignUpController _signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isIdValid =  _signUpController.userEmail.value.contains('@')
        && _signUpController.userEmail.value.contains('.');
    bool isPwValid = _signUpController.userPassword.value.length >= 6;
    bool isPwCheckValid = _signUpController.userPassword.value == _signUpController.userPasswordCheck.value
        && isPwValid;
    bool isValid = isIdValid && isPwCheckValid;

    return Scaffold(
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
                        EntryField(
                            fieldName: '아이디',
                            fieldId: 1,
                            inputType: TextInputType.emailAddress,
                            errorMessage: "올바른 이메일 형식을 입력해 주세요",
                            hintText: '이메일을 입력해 주세요',
                            isValid: isIdValid,
                            onChanged: (value) => _signUpController.userEmail.value = value,
                        ),
                        // 아이디
                        SizedBox(height: height*0.05,),
                        EntryField(
                            fieldName: "비밀번호",
                            fieldId: 2,
                            errorMessage: '6글자 이상을 입력해 주세요',
                            hintText: '비밀번호를 입력해 주세요',
                            isPassword: true,
                            isValid: isPwValid,
                            onChanged: (value) => _signUpController.userPassword.value = value
                        ),
                        // 비밀번호
                        SizedBox(height: height*0.05,),
                        EntryField(
                            fieldName: "비밀번호 확인",
                            fieldId: 3,
                            errorMessage: '올바른 비밀번호를 입력해 주세요',
                            hintText: '비밀번호를 한 번 더 입력해 주세요',
                            isPassword: true,
                            isValid: isPwCheckValid,
                            onChanged: (value) => _signUpController.userPasswordCheck.value = value
                        ),
                        NextBtn(isButtonDisabled: !isValid, nextPage: SignUpScreen3()),
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
