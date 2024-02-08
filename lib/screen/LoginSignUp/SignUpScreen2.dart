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
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String userId = "";
  String userPw = "";
  String userPwCheck = "";
  String? _errorMessage;

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
                                  fontSize: 24
                              ),),
                            TextFormField(
                                onChanged: (value) {
                                  signUpController.userEmail.value = value;
                                  setState(() {
                                    userId = value;
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return "유효한 이메일 주소를 입력해 주세요";
                                  }
                                  return null; // 유효성 검사에 성공한 경우 null 반환
                                },
                                decoration: InputDecoration(
                                  hintText: '이메일을 입력해 주세요',
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3)
                                  ),
                                  errorText: !userId.contains('@') || !userId.contains('.') ? '올바른 이메일 형식을 입력해 주세요' : null, // 오류 메시지 표시
                                ),
                               onSaved: (value){
                                 userId = value!;
                               },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('비밀번호',
                              style: TextStyle(
                                  fontSize: 24
                              ),),
                            TextFormField(
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
                                hintText: '비밀번호를 입력해 주세요',
                                hintStyle: TextStyle(
                                    fontSize: 30,
                                    color: const Color(0xffB3B3B3)
                                  ),
                                errorText: userPw.length <6 ? '6글자 이상을 입력해 주세요' : null, // 오류 메시지 표시
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('비밀번호 확인',
                              style: TextStyle(
                                  fontSize: 24
                              ),
                            ),
                            TextFormField(
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
                                  hintText: '비밀번호를 입력해 주세요',
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3)
                                  ),
                                  errorText: userPw != userPwCheck ? '비밀번호가 일치하지 않습니다' :  userPwCheck.length < 6 ? '6글자 이상을 입력해 주세요' : null, // 오류 메시지 표시
                                ),
                                onSaved: (value){
                                  userPwCheck = value!;
                                },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              _tryValidation();
                              try {
                                final newUser = await _authentication.createUserWithEmailAndPassword(
                                    email: userId,
                                    password: userPw);
                                if (newUser.user != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignUpScreen3();
                                    }
                                    )
                                  );
                                }
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
                              backgroundColor: const Color(0xffFFC215),
                            ),
                            child: Container(
                                width: 350,
                                height: height*0.07,
                                alignment: Alignment.center,
                                child: Text('다음',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color:  Color(0xff000000),
                                    )
                                )
                            )
                        ),
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
