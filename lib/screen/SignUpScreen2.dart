import 'package:flutter/material.dart';

class SignUpScreen2 extends StatefulWidget {
  SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                            style: TextStyle(
                                fontSize: 30
                            ),
                            decoration: InputDecoration(
                              hintText: "비밀번호를 입력해 주세요",
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
                        Text('비밀번호 확인',
                          style: TextStyle(
                              fontSize: 24
                          ),
                        ),
                        TextFormField(
                            style: TextStyle(
                                fontSize: 30
                            ),
                            decoration: InputDecoration(
                              hintText: "비밀번호를 한 번 더 입력해 주세요",
                              hintStyle: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xffB3B3B3)
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 250,),
                  Container(
                    child: ElevatedButton(
                        onPressed: ()=>{},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFC215),
                        ),
                        child: Container(
                            width: 350,
                            height: 60,
                            alignment: Alignment.center,
                            child: Text('다음',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xff000000),
                                )
                            )
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
