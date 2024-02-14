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
  bool isTaped = false;
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  void bottombarToggle() {
    setState(() {
      isTaped = !isTaped;
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    void getCurrentUser(){
      try {
        final user = _authentication.currentUser;
        if (user != null){
          loggedUser = user;
        };
      }
      catch (e) {
        print(e);
      }
    }
    return Scaffold(
        body: GestureDetector(
          onTap: (){
            bottombarToggle();
          },
          child: Container(
            child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      top: isTaped ? height* 0.15 : height*0.3,
                      left: width*0.3,
                      width: width*0.4,
                      child: Image.asset('lib/assets/images/LogInSignUpMainATTI.png'),
                    ),
                    Positioned.fill(child:
                    GestureDetector(
                      onTap: () {
                        bottombarToggle();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    )
                    ),
                    // if (loggedUser == null)
                    Positioned(
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        height: isTaped ? height*0.4 : 0,
                        width: width,
                        // 잘 안됨 왜 안되지 ??????
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              color: Color(0xffFFE9B3)
                            ),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('반가워요! 저는 아띠에요!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text('서비스 이용을 위해 로그인 해주세요.',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text('만약 앱 사용이 처음이시라면 회원가입을',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text('진행해주세요.',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height*0.025,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) {
                                                return LogInScreen();
                                              }
                                              )
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xffFFC215)
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: width*0.32,
                                          height: 60,
                                          child: Text('로그인',
                                          style: TextStyle(
                                            color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold
                                          ),),
                                    )),
                                    SizedBox(width: width*0.025,),
                                    ElevatedButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) {
                                                return SignUpScreen1();
                                              }
                                              )
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xffFFF5DB),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: width*0.32,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Color(0xffFFF5DB),
                                          ),
                                          child: Text('회원가입',
                                          style: TextStyle(
                                            color: Color(0xffA38130),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold
                                          ),),
                                        ))
                                  ],
                                ),
                                SizedBox(height: height*0.5,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
              ),
          ),
        ),
    );
  }
}
