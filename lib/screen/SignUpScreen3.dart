import 'package:atti/screen/FinishSignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen3 extends StatefulWidget {
  SignUpScreen3({super.key});

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null){
        loggedUser = user;
        print(loggedUser!.email);
      };
    }
    catch (e) {
      print(e);
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
                // key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이름',
                              style: TextStyle(
                                  fontSize: 24
                              ),),
                            TextFormField(
                                // onChanged: (value){
                                //   userId = value;
                                // },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 4) {
                                    return "n글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                // onSaved: (value){
                                //   userId = value!;
                                // },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "이름을 입력해주세요",
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
                            Text('생년월일',
                              style: TextStyle(
                                  fontSize: 24
                              ),),
                            TextFormField(
                                // onChanged: (value){
                                //   userPw = value;
                                // },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 6) {
                                    return "n글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                // onSaved: (value){
                                //   userPw = value!;
                                // },
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
                                  hintText: "연월일",
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
                            Text('가족 구성원',
                              style: TextStyle(
                                  fontSize: 24
                              ),
                            ),
                            TextFormField(
                                obscureText: true,
                                // onChanged: (value){
                                //   userPwCheck = value;
                                // },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 6) {
                                    return "n글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                // onSaved: (value){
                                //   userPwCheck = value!;
                                // },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "구성원의 이름을 입력해주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3)
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 100,),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              // _tryValidation();
                              // if(isSignUpScreen)
                              // try {
                                // final newUser = await _authentication.createUserWithEmailAndPassword(
                                //     email: userId,
                                //     password: userPw);
                                // if (newUser.user != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return FinishSignUpScreen();
                                        }
                                      )
                                  );
                                },
                              // }
                              // catch (e) {
                              //   print(e);
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //       content:
                                //       Text('이메일 또는 패스워드를 확인해 주세요'),
                                //       backgroundColor: Colors.blue,
                                //     )
                                // );
                              // }
                            // },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFC215),
                            ),
                            child: Container(
                                width: 350,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text('가입하기',
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
