import 'package:atti/screen/LogInSignUp/LogInScreen.dart';
import 'package:flutter/material.dart';

class FinishSignUpScreen extends StatefulWidget {
  const FinishSignUpScreen({super.key});

  @override
  State<FinishSignUpScreen> createState() => _FinishSignUpScreenState();
}

class _FinishSignUpScreenState extends State<FinishSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFFC215),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: height*0.15, left: 20),
            child: Text(
              '회원가입이\n완료되었어요!',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height*0.32, left: 20),
            child: Text(
              '방금 생성한 계정으로 로그인해서\n아띠를 만나러 가볼게요!',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height*0.2, left: 10, right: 10),
            alignment: Alignment.center,
            child: Image.asset('lib/assets/images/FinishSignUpImage.png'),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: height*0.8, left: 10, right: 10),
            child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return LogInScreen();
                      }
                      )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: width*0.02),
                    height: height*0.07,
                    alignment: Alignment.center,
                    child: Text('로그인',
                        style: TextStyle(
                          fontSize: 24,
                          color: const Color(0xff000000),
                        )
                    )
                )
            ),
          ),
        ],
      ),
    );
  }
}
