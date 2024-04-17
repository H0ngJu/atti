import 'package:atti/commons/colorPallet.dart';
import 'package:atti/screen/LogInSignUp/LogInScreen.dart';
import 'package:atti/screen/LogInSignUp/SignUpScreen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInSignUpMainScreen extends StatefulWidget {
  LogInSignUpMainScreen({super.key});

  @override
  State<LogInSignUpMainScreen> createState() => _LogInSignUpMainScreenState();
}

class _LogInSignUpMainScreenState extends State<LogInSignUpMainScreen> {
  User? loggedUser;
  ColorPallet _colorPallet = ColorPallet();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            width: width,
            height: height,
            child: Column(
                  children: [
                      Container(
                        width: width,
                        height: height*0.4,
                        margin: EdgeInsets.only(top: height * 0.15),
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                              'lib/assets/images/LoginSignupPageATTI.png',
                              width: width * 0.7,
                          ),
                        ),
                    ),
                    // 구분선
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                      child: Divider(
                        color: Color(0xffE1E1E1),
                      ),
                    ),
                    Text("반가워요! 저는 아띠에요!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("서비스 이용을 위해 로그인 해주세요.\n만약 앱 사용이 처음이시라면 회원가입을\n진행해주세요.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // 회원가입, 로그인 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width*0.4,
                          height: height*0.08,
                          child: TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                        return LogInScreen();
                                      }
                                    )
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: _colorPallet.goldYellow,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: _colorPallet.goldYellow,
                                      width: 1,
                                    ),
                                  borderRadius: BorderRadius.circular(30)
                                )
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text('로그인',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600
                                  ),),
                              )),
                        ),
                        SizedBox(width: width*0.025,),
                        SizedBox(
                          width: width*0.4,
                          height: height*0.08,
                          child: TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignUpScreen1();
                                    }
                                    )
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                  borderRadius: BorderRadius.circular(30))
                                )
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text('회원가입',
                                  style: TextStyle(
                                    color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ],
            ),
        ),
    );
  }
}
