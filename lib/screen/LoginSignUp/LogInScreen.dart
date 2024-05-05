import 'package:atti/data/signup_login/LoginController.dart';
import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:atti/screen/LoginSignUp/IntroPage.dart';
import 'package:atti/screen/LoginSignUp/LoginEntryField.dart';
import 'package:atti/screen/LoginSignUp/NextBtn.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:get/get.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final LoginController _loginController = Get.put(LoginController());
  // final _authentication = FirebaseAuth.instance;
  // final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isIdValid =  _loginController.userEmail.value.contains('@')
        &&  _loginController.userEmail.value.contains('.');
    bool isPasswordValid = _loginController.userPassword.value.length >= 6;
    bool isValid = isIdValid && isPasswordValid;
    bool loginSuccess;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.all(5),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LogInSignUpMainScreen();
                  })
              );
            },
            icon: const Icon(Icons.navigate_before,
              size: 40,
            )
        ),
        title: Text('로그인',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'PretendardBold', // ================================================================================================
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, left: 20, right: 20),
              child: Form(
                // key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      LoginEntryField(
                        fieldName: "아이디",
                        fieldId: 1,
                        errorMessage: '올바른 이메일 형식을 입력해 주세요',
                        hintText: "이메일을 입력해 주세요",
                        inputType: TextInputType.emailAddress,
                        isValid: isIdValid,
                        onChanged: (value) => _loginController.userEmail.value = value,
                      ),
                      LoginEntryField(
                          fieldName: "비밀번호",
                          fieldId: 2,
                          errorMessage: '6글자 이상의 비밀번호를 입력해 주세요',
                          hintText: "비밀번호를 입력해 주세요",
                          isPassword: true,
                          isValid: isPasswordValid,
                          onChanged: (value) => _loginController.userPassword.value = value,
                      ),
                      SizedBox(height: height*0.01,),
                      Row(
                        children: [
                          TextButton(onPressed: (){}, child: Text('아이디 찾기',
                            style: TextStyle(
                              color: Color(0xffB3B3B3),
                              fontSize: 20,
                              fontFamily: 'PretendardRegular',
                            ),
                          )
                          ),
                          Text('|',
                              style: TextStyle(
                                color: Color(0xffB3B3B3),
                                fontSize: 20,
                                fontFamily: 'PretendardRegular',
                              )
                          ),
                          TextButton(onPressed: (){}, child: Text('비밀번호 찾기',
                              style: TextStyle(
                                color: Color(0xffB3B3B3),
                                fontSize: 20,
                                fontFamily: 'PretendardRegular',
                              )
                          )
                          ),
                        ],
                      ),
                      // 아이디 비밀번호 찾기
                      SizedBox(height: height*0.1,),
                      NextBtn(
                        buttonName: "로그인",
                        isButtonDisabled: !isValid,
                        onButtonClick: () async {
                          loginSuccess = await _loginController.login(); // 로그인 시도 후 결과 저장
                          if (loginSuccess) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => IntroPage())); // 로그인 성공 시 페이지 이동
                          }
                        },
                      ),
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
