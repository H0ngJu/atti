import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';


class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Color borderColor = Color(0xffB3B3B3);
  Color pressedBorderColor = Color(0xffFFC215);
  int isPressed = 0;
  void topBtnPressed() {
    setState(() {
      isPressed == 1 ? isPressed = 0 : isPressed = 1;
    });
  }
  void botBtnPressed() {
    setState(() {
      isPressed == 2 ? isPressed = 0 : isPressed = 2;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 90, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      '회원가입',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Text(
                    '회원선택',
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '서비스 이용이 구분되니 신중히 선택해주세요',
                  style: TextStyle(
                    color: Color(0xffB3B3B3),
                    fontSize: 20,
                  ),
                ),
              ],
            )
            ),
          Container(
            margin: EdgeInsets.only(top: 250, left: 20),
            child: Column(
              children: [
                ElevatedButton(onPressed: ()=>{
                  topBtnPressed()
                },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(width: 2, color: isPressed == 1 ? pressedBorderColor : borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                        ),
                      ),
                    elevation: 0,
                    ),
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/images/membershipType_patient_bg.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '피보호자',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '치매 증상을 지니셨나요?',
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: ()=>{
                  botBtnPressed()
                },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: BorderSide(width: 2, color: isPressed == 2 ? pressedBorderColor : borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/images/membershipType_carer_bg.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '보호자',
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '치매 환자의 보호자이신가요?',
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,),
                Visibility(
                  visible: isPressed != 0,
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
                        ),
                      ),
                    )
                )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}