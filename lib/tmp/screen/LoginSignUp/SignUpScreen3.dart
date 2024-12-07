import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:atti/tmp/screen/LoginSignUp/EntryField.dart';
import 'package:atti/tmp/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:atti/tmp/screen/LoginSignUp/NextBtn.dart';
import 'package:atti/tmp/screen/LoginSignUp/SignUpFamilyTag.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:atti/commons/colorPallet.dart';

class SignUpScreen3 extends StatefulWidget {
  SignUpScreen3({super.key});

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final SignUpController _signUpController = Get.put(SignUpController());
  // final SignUpController _signUpController = Get.find<SignUpController>();
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _formKey = GlobalKey<FormState>();

  User? loggedUser;
  DateTime userBirthDate = DateTime.now();
  String formattedDate = "연도 / 월 / 일을 선택해 주세요";

  // 데이트피커도 가능하면 바꾸기
  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      minDateTime: DateTime(1900),
      title: '생년월일을 입력해 주세요',
      titleStyle: TextStyle(
        fontSize: 24, fontWeight: FontWeight.normal,
        fontFamily: 'PretendardRegular',
      ),
      dateOrder: DatePickerDateOrder.ymd,
      pickerTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontFamily: 'PretendardRegular',
      ),
      displayCloseIcon: false,
      onSubmit: (value) {
        if (value != null) {
          _signUpController.userBirthDate = value; // check
          setState(() {
            userBirthDate = value;
            formattedDate = DateFormat('yyyy년 MM월 dd일').format(userBirthDate);
          });
        }
      },
      buttonContent: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Text('선택', style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500,
            fontFamily: 'PretendardRegular',
        ),
        textAlign: TextAlign.center,),
      ),
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      buttonStyle: BoxDecoration(
        color: Color(0xffFFC215),
        borderRadius: BorderRadius.circular(15),
      ),
      buttonWidth: MediaQuery.of(context).size.width * 0.5,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isNameValid =  _signUpController.userName.value.length >= 2;
    bool isPhoneValid = _signUpController.userPhoneNumber.value.length >= 10;
    bool isPatientEmailValid = _signUpController.userPatientEmail.value.contains("@") && _signUpController.userPatientEmail.value.contains(".");
    bool isValid = _signUpController.isPatient.value ?
      isNameValid && isPhoneValid : // 피보호자라면 + 생일 정보도
      isNameValid && isPhoneValid && isPatientEmailValid; // 보호자라면

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            DetailPageTitle(
              title: '회원가입',
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
                    children: [
                      EntryField(
                          fieldName: "이름",
                          fieldId: 4,
                          errorMessage: "2글자 이상을 입력해 주세요",
                          hintText: "이름을 입력해주세요",
                          isValid: isNameValid,
                          onChanged: (value)=>_signUpController.userName.value = value
                      ),
                      // 1 이름
                      if (_signUpController.isPatient.value)
                        SizedBox(height: height * 0.05,),
                      if (_signUpController.isPatient.value)
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text('생년월일',
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'PretendardRegular',
                            ),
                          ),
                        ),
                      // 생년월일 타이틀
                      if (_signUpController.isPatient.value)
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: height*0.01),
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                          decoration: BoxDecoration(
                            color: colorPallet.lightYellow,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: _signUpController.isPressed.value == 5? colorPallet.textColor : colorPallet.lightYellow,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _openDatePicker(context);
                                  setState(() {
                                    _signUpController.isPressed.value = 5;
                                  });
                                },
                                child: Text("${formattedDate}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: formattedDate == "연도 / 월 / 일을 선택해 주세요" ? colorPallet.textColor : Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'PretendardRegular',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // 2 생년월일 입력폼
                      SizedBox(height: height * 0.05,),
                      EntryField(
                        fieldName: "전화번호",
                        fieldId: 6,
                        errorMessage: "유효한 전화번호를 입력해 주세요",
                        hintText: '01012345678',
                        isValid: isPhoneValid,
                        onChanged: (value)=>_signUpController.userPhoneNumber.value = value
                      ),
                      // 3 전화번호
                      if (!_signUpController.isPatient.value)
                      SizedBox(height: height * 0.05,),
                      if (!_signUpController.isPatient.value)
                        EntryField(
                          fieldName: "피보호자 아이디",
                          fieldId: 7,
                          errorMessage: "유효한 이메일 주소를 입력해 주세요",
                          hintText: '이메일을 입력해 주세요',
                          isValid: isPatientEmailValid,
                          onChanged: (value)=>_signUpController.userPatientEmail.value = value
                        ),
                      // 4 피보호자 아이디
                      if (_signUpController.isPatient.value)
                        SizedBox(height: height * 0.05,),
                      if (_signUpController.isPatient.value)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('가족 구성원',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'PretendardRegular',
                                ),
                              ),
                          // TagTest(),
                              Container(
                                margin: EdgeInsets.only(top: height*0.01),
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                                decoration: BoxDecoration(
                                  // color: colorPallet.yellow,
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: _signUpController.isPressed.value == 8? colorPallet.textColor : colorPallet.lightYellow,
    // press 제대로 작동하는지 확인 =======================================================================================
                                  ),
                                ),
                                child: Container(
                                    margin: EdgeInsets.only(top: height*0.01),
                                    padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                                    width: width*0.9,
                                    height: height*0.2,
                                    child: SignUpFamilyTag()
                                ),
                              )
                            ],
                          ),
                        ),
                      // 5 가족 구성원
                      // SizedBox(height: height * 0.1,),
                    NextBtn(
                        isButtonDisabled: !isValid,
                        nextPage: FinishSignUpScreen(),
                        onButtonClick: _signUpController.signUp,
                        buttonName: "회원가입",
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