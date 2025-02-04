import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/login_signUp/SignUpScreen4.dart';
import 'package:atti/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:atti/commons/colorPallet.dart';

class SignUpScreen4 extends StatefulWidget {
  SignUpScreen4({super.key});

  @override
  State<SignUpScreen4> createState() => _SignUpScreen4State();
}

class _SignUpScreen4State extends State<SignUpScreen4> {
  final SignUpController _signUpController = Get.put(SignUpController());
  // final SignUpController _signUpController = Get.find<SignUpController>();
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _formKey = GlobalKey<FormState>();

  User? loggedUser;
  DateTime userBirthDate = DateTime.now();
  String formattedDate = "연도 / 월 / 일을 선택해 주세요";

  @override
  Widget build(BuildContext context) {

    ColorPallet _colorPallet = ColorPallet();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String formatDateTime(DateTime dateTime) {
      String year = dateTime.year.toString().substring(2); // 연도의 마지막 두 자리
      String month = dateTime.month.toString().padLeft(2, '0'); // 월을 두 자리로
      String day = dateTime.day.toString().padLeft(2, '0'); // 일을 두 자리로

      return '$year$month$day'; // 원하는 형식으로 조합
    }

    String userNumber = formatDateTime(_signUpController.userBirthDate!);
    String userPhoneNumber = "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            DetailPageTitle(
              title: '본인인증',
              description: '',
              totalStep: 3,
              currentStep: 3,
            ),

            Container(
              margin: EdgeInsets.only(top: height * 0.2, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '휴대폰 번호를 입력해 주세요.',
                        style: TextStyle(
                          letterSpacing: 0.01,
                          fontSize: 24,
                          fontFamily: 'PretendardRegular',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start, // 수평 정렬
                        crossAxisAlignment: CrossAxisAlignment.center, // 수직 정렬
                        children: [
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.symmetric(vertical: 9.0, horizontal: 9.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF5DB),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Text(
                              "010",
                              style: TextStyle(
                                letterSpacing: 0.01,
                                fontSize: 24,
                                fontFamily: 'PretendardRegular',
                              ),
                            ),
                          ),
                          SizedBox(width: width*0.01), // 두 위젯 사이의 간격 추가
                          Container(
                            // margin: EdgeInsets.only(top: height * 0.01),
                            width: width * 0.66, // 너비를 조정
                            padding: EdgeInsets.symmetric(horizontal: 9.0),
                            decoration: BoxDecoration(
                              color: _colorPallet.lightYellow,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: TextFormField(
                              onTap: () {
                                setState(() {
                                  _signUpController.isPressed.value = 1;
                                });
                                print("isPressed = ${_signUpController.isPressed.value}\nfieldId = ${1}");
                              },
                              onChanged: (value) {
                                _signUpController.userPhoneNumber.value = value;
                                _signUpController.scrn4_btnIsValid.value = _signUpController.userPhoneNumber.value.length == 8;
                                print("입력된 전화번호: ${_signUpController.userPhoneNumber.value}");
                            },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "12345678",
                                hintStyle: TextStyle(
                                  fontSize: 24,
                                  color: _colorPallet.textColor,
                                  fontFamily: 'PretendardRegular',
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'PretendardRegular',
                              ),
                            ),
                          ),
                        ],
                      ),
                    TextButton(
                      onPressed: _signUpController.scrn4_btnIsValid.value ? null : () async {
                        _signUpController.userPhoneNumber.value = "010${_signUpController.userPhoneNumber.value}";
                        print("유저 전화번호: ${_signUpController.userPhoneNumber.value}");
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: _signUpController.scrn4_btnIsValid.value ? BorderSide(color: _colorPallet.orange) : BorderSide(color: Colors.black), // 테두리 색상
                        ),
                        backgroundColor: _signUpController.scrn4_btnIsValid.value ? _colorPallet.orange : Colors.white, // 배경 색상
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: width*0.9,
                        child: Text(
                          "인증번호 발송하기",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'PretendardRegular', // 원하는 폰트
                            color: Colors.black, // 텍스트 색상
                          ),
                        ),
                      ),
                    ),
                      //
                      if (_signUpController.scrn4_btnIsValid.value)
                        Container(
                          width: width * 0.9,
                          padding: EdgeInsets.symmetric(horizontal: 9.0),
                          decoration: BoxDecoration(
                            color: _colorPallet.lightYellow,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                _signUpController.isPressed.value = 1;
                              });
                              print("isPressed = ${_signUpController.isPressed.value}\nfieldId = ${1}");
                            },
                            onChanged: (value) {
                              _signUpController.authCode.value = value;
                              // 인증코드 로직 추가
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "000000",
                              hintStyle: TextStyle(
                                fontSize: 24,
                                color: _colorPallet.textColor,
                                fontFamily: 'PretendardRegular',
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'PretendardRegular',
                            ),
                          ),
                        ),
                      TextButton(
                        onPressed: _signUpController.scrn4_btnIsValid.value ? null : () async {
                          _signUpController.userPhoneNumber.value = "010${_signUpController.userPhoneNumber.value}";
                          print("유저 전화번호: ${_signUpController.userPhoneNumber.value}");
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: _signUpController.scrn4_codeIsValid.value ? BorderSide(color: _colorPallet.orange) : BorderSide(color: Colors.black), // 테두리 색상
                          ),
                          backgroundColor: _signUpController.scrn4_codeIsValid.value ? _colorPallet.orange : Colors.white, // 배경 색상
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: width*0.9,
                          child: Text(
                            "인증번호 확인",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'PretendardRegular', // 원하는 폰트
                              color: Colors.black, // 텍스트 색상
                            ),
                          ),
                        ),
                      ),
                      // 생년월일
                      Container(
                        margin: EdgeInsets.only(top: height*0.01),
                        width: width*0.9,
                        // height: height*0.08,
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 7.0, left: 9.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF5DB),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          "${userNumber} - ${_signUpController.userSex.value}●●●●●●",
                          style: TextStyle(
                            letterSpacing: 0.01,
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      // 이름
                      Container(
                        margin: EdgeInsets.only(top: height*0.01),
                        width: width*0.9,
                        // height: height*0.08,
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 7.0, left: 9.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF5DB),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Text(
                          _signUpController.userName.value,
                          style: TextStyle(
                            letterSpacing: 0.01,
                            fontSize: 24,
                            fontFamily: 'PretendardRegular',
                          ),
                        ),
                      ),
                      NextBtn(
                        isButtonDisabled: !_signUpController.scrn4_isValid.value,
                        nextPage: SignUpScreen4(),
                        buttonName: "확인",
                        onButtonClick: (){

                        },
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