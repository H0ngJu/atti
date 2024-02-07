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
    return Scaffold(
      backgroundColor: Color(0xffFFC215),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 130, left: 20),
            child: Text(
              '회원가입이',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 175, left: 20),
            child: Text(
              '완료되었어요!',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 240, left: 20),
            child: Text(
              '방금 생성한 계정으로 로그인해서',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 270, left: 20),
            child: Text(
              '아띠를 만나러 가볼게요!',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            child: Image.asset('lib/assets/images/FinishSignUpImage.png'),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 700),
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
                    width: 300,
                    height: 60,
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
