import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/SignUpController.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen3.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignUpScreen2 extends StatefulWidget {
  SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final SignUpController signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  String userId = "";
  String userPw = "";
  String userPwCheck = "";

  int isPressed = 0;
  var alertColor = Color(0xffB62E26);
  var boxDefaultColor = Color(0xffFFE9B3);
  var boxFocusedColor = Color(0xffA38130);

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if (userPw != userPwCheck) {
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('아이디',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                              decoration: BoxDecoration(
                                color: boxDefaultColor,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: isPressed == 1? boxFocusedColor : boxDefaultColor,
                                ),
                              ),
                              child: TextFormField(
                                onTap: () {
                                  setState(() {
                                    isPressed = 1;
                                  });
                                },
                                onChanged: (value) {
                                      signUpController.userEmail.value = value;
                                      setState(() {
                                        userId = value;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty || !value.contains('@')) {
                                        return "올바른 이메일 형식을 입력해 주세요";
                                      }
                                      return null; // 유효성 검사에 성공한 경우 null 반환
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '이메일을 입력해 주세요',
                                      hintStyle: TextStyle(
                                          fontSize: 24,
                                          color: boxFocusedColor,
                                      ),
                                      // errorText: !userId.contains('@') || !userId.contains('.') ? '올바른 이메일 형식을 입력해 주세요' : null, // 오류 메시지 표시
                                    ),
                                   onSaved: (value){
                                     userId = value!;
                                   },
                                    style: TextStyle(
                                        fontSize: 24
                                    ),
                                ),
                            ),
                            if (!userId.contains('@') || !userId.contains('.'))
                            Container(
                              child: Text(
                                  '올바른 이메일 형식을 입력해 주세요',
                                style: TextStyle(
                                  color: alertColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // 아이디
                      SizedBox(height: height*0.05,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('비밀번호',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                              ),),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                              decoration: BoxDecoration(
                                color: boxDefaultColor,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: isPressed == 2? boxFocusedColor : boxDefaultColor,
                                ),
                              ),
                              child: TextFormField(
                                onTap: () {
                                  setState(() {
                                    isPressed = 2;
                                  });
                                },
                                  obscureText: true,
                                  onChanged: (value) {
                                    signUpController.userPassword.value = value;
                                    setState(() {
                                      userPw = value;
                                    });
                                },
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return '6글자 이상을 입력해 주세요'; // 유효성 검사에 실패할 경우 메시지 반환
                                  }
                                  return null; // 유효성 검사에 성공한 경우 null 반환
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '비밀번호를 입력해 주세요',
                                  hintStyle: TextStyle(
                                      fontSize: 24,
                                      color: boxFocusedColor,
                                  ),
                                ),
                                style: TextStyle(
                                    fontSize: 24
                                ),
                              ),
                            ),
                            if (userPw.length <6)
                              Container(
                                child: Text(
                                  '6글자 이상을 입력해 주세요',
                                  style: TextStyle(
                                    color: alertColor,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      // 비밀번호
                      SizedBox(height: height*0.05,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('비밀번호 확인',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                 fontSize: 24
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                              decoration: BoxDecoration(
                                color: boxDefaultColor,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: isPressed == 3? boxFocusedColor : boxDefaultColor,
                                ),
                              ),
                              child: TextFormField(
                                onTap: () {
                                  setState(() {
                                    isPressed = 3;
                                  });
                                },
                                  obscureText: true,
                                  onChanged: (value) {
                                    setState(() {
                                      userPwCheck = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return '6글자 이상을 입력해 주세요'; // 유효성 검사에 실패할 경우 메시지 반환
                                    }
                                    if (value != userPw) {
                                      return "비밀번호가 일치하지 않습니다.";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '비밀번호를 입력해 주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        color: boxFocusedColor,
                                    ),
                                  ),
                                  onSaved: (value){
                                    userPwCheck = value!;
                                  },
                                style: TextStyle(
                                    fontSize: 24
                                ),
                              ),
                            ),
                            if (userPw != userPwCheck || userPwCheck.length < 6)
                              Container(
                                child: Text(
                                  userPw != userPwCheck ? '비밀번호가 일치하지 않습니다' : '6글자 이상을 입력해 주세요',
                                  style: TextStyle(
                                    color: alertColor,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      // 비밀번호 확인
                      SizedBox(height: height*0.05),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              _tryValidation();
                              try {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignUpScreen3();
                                    }
                                    )
                                );
                              }
                              catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                      Text('이메일 또는 패스워드를 확인해 주세요',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Color(0xffFFC215),
                                    )
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFF5DB),
                            ),
                            child: Container(
                                width: 350,
                                height: height*0.07,
                                alignment: Alignment.center,
                                child: Text('다음',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: boxFocusedColor,
                                      fontWeight: FontWeight.bold,
                                    )
                                )
                            )
                        ),
                      )
                      // 다음 버튼
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
