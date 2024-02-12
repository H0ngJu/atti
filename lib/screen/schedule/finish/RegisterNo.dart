// 피그마 '사진 등록 No' 화면
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/screen/HomePatient.dart';

class RegisterNo extends StatelessWidget {
  const RegisterNo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffFFEEBC),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 100.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.only(left: 15),
                    child: Text('기억을 등록하지\n않았어요.', style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w600, color: Color(0xffA38130)
                    ),),
                  ),
                  SizedBox(height: 80,),
                  Container(
                    //margin: EdgeInsets.only(left: 50),
                    child: Image.asset('lib/assets/images/hurrayatti.png',
                      width: 230,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
            NextButton(next: HomePatient(), content: '홈으로 돌아가기', isEnabled: true)
          ],
        ));
  }
}
