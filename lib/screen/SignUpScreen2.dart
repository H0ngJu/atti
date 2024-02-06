import 'package:atti/screen/SignUpScreen3.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen2 extends StatefulWidget {
  SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final _authentication = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String userId = "";
  String userPw = "";
  String userPwCheck = "";

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 90, left: 20),
              child: Text(
                '회원가입',
                style: TextStyle(
                  letterSpacing: 1.0,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200, left: 20, right: 20),
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
                              onChanged: (value){
                                userId = value;
                              },
                              validator: (value){
                                if (value!.isEmpty || value.length < 4) {
                                  return "n글자 이상을 입력해 주세요";
                                }
                                return null;
                              },
                                onSaved: (value){
                                  userId = value!;
                                },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "아이디를 입력해 주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xffB3B3B3)
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
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
                              onChanged: (value){
                                userPw = value;
                              },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 6) {
                                    return "n글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  userPw = value!;
                                },
                                // keyboardType: TextInputType.emailAddress,
                              // validator: (value) {
                              //   if (value!.isEmpty || !value.contains('@')) {
                              //     return "유효한 이메일 주소를 입력해 주세요";
                              //   }
                              //   return null;
                              // },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "비밀번호를 입력해 주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3)
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
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
                              onChanged: (value){
                                userPwCheck = value;
                              },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 6) {
                                    return "n글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                onSaved: (value){
                                  userPwCheck = value!;
                                },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "비밀번호를 한 번 더 입력해 주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3)
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 250,),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              _tryValidation();
                              // if(isSignUpScreen)
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
                                    Text('이메일 또는 패스워드를 확인해 주세요'),
                                      backgroundColor: Colors.blue,
                                    )
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFC215),
                            ),
                            child: Container(
                                width: 350,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text('다음',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: const Color(0xff000000),
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
