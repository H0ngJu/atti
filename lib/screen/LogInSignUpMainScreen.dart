import 'package:atti/screen/LogInScreen.dart';
import 'package:atti/screen/SignUpScreen1.dart';
import 'package:flutter/material.dart';

class LogInSignUpMainScreen extends StatefulWidget {
  LogInSignUpMainScreen({super.key});

  @override
  State<LogInSignUpMainScreen> createState() => _LogInSignUpMainScreenState();
}

class _LogInSignUpMainScreenState extends State<LogInSignUpMainScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 270,
            left: 130,
            child: Image.asset('lib/assets/images/LogInSignUpMainATTI.png'),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              height: height*0.35,
              width: width,
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
                  SizedBox(height: 20,),
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
                              color: Colors.black,
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
                              backgroundColor: Colors.white,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: width*0.32,
                            height: 60,
                            child: Text('회원가입',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
