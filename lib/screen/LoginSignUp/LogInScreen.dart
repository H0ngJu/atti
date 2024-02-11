import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
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
  var isPressed = 0;
  String userId = "";
  String userPassword = "";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: EdgeInsets.all(5),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LogInSignUpMainScreen();
                  }
                  )
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
          ),
        ),
      ),
      body: GestureDetector(
        onTap: (){
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
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('아이디',
                              style: TextStyle(
                                  fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                              decoration: BoxDecoration(
                                color: colorPallet.yellow,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: isPressed == 1? colorPallet.textColor : colorPallet.yellow,
                                ),
                              ),
                              child: TextFormField(
                                  onTap: (){
                                    setState(() {
                                      isPressed = 1;
                                    });
                                  },
                                  onChanged: (value){
                                    setState(() {
                                      userId = value;
                                    });
                                  },
                                  validator: (value){
                                    if (value!.isEmpty || value.length < 4) {
                                      return "n글자 이상을 입력해 주세요";
                                    }
                                    return null;
                                  },
                                  // onSaved: (value){
                                  //   userId = value!;
                                  // },
                                  style: TextStyle(
                                      fontSize: 24
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "이메일을 입력해 주세요",
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        color: colorPallet.textColor
                                    ),
                                  )
                              ),
                            ),
                            // if (!userId.contains('@') || !userId.contains('.'))
                            //   Container(
                            //     child: Text(
                            //       '올바른 이메일 형식을 입력해 주세요',
                            //       style: TextStyle(
                            //         color: colorPallet.alertColor,
                            //       ),
                            //     ),
                            //   )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.02,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('비밀번호',
                              style: TextStyle(
                                  fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                              decoration: BoxDecoration(
                                color: colorPallet.yellow,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: isPressed == 2? colorPallet.textColor : colorPallet.yellow,
                                ),
                              ),
                              child: TextFormField(
                                onTap: (){
                                  setState(() {
                                    isPressed = 2;
                                  });
                                },
                                  obscureText: true,
                                  onChanged: (value){
                                    setState(() {
                                      userPassword = value;
                                    });
                                  },
                                  validator: (value){
                                    if (value!.isEmpty || value.length < 6) {
                                      return "6글자 이상을 입력해 주세요";
                                    }
                                    return null;
                                  },
                                  // onSaved: (value){
                                  //   userPw = value!;
                                  // },
                                  keyboardType: TextInputType.emailAddress,
                                  // validator: (value) {
                                  //   if (value!.isEmpty || !value.contains('@')) {
                                  //     return "유효한 이메일 주소를 입력해 주세요";
                                  //   }
                                  //   return null;
                                  // },
                                  style: TextStyle(
                                      fontSize: 24
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "비밀번호를 입력해 주세요",
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        color: colorPallet.textColor,
                                    ),
                                  )
                              ),
                            ),
                            // if (userPassword.length < 6)
                            //   Container(
                            //     child: Text(
                            //       '6글자 이상의 비밀번호를 입력해 주세요',
                            //       style: TextStyle(
                            //         color: colorPallet.alertColor,
                            //       ),
                            //     ),
                            //   )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05,),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              // _tryValidation();
                              // if(isSignUpScreen)
                              // try {
                              //   final newUser = await _authentication.createUserWithEmailAndPassword(
                              //       email: userId,
                              //       password: userPw);
                              //   if (newUser.user != null) {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(builder: (context) {
                              //           return SignUpScreen3();
                              //           }
                              //         )
                              //     );
                                // }
                              // }
                              // catch (e) {
                              //   print(e);
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //         content:
                              //         Text('이메일 또는 패스워드를 확인해 주세요'),
                              //         backgroundColor: Colors.blue,
                              //       )
                              //   );
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPallet.lightYellow,
                            ),
                            child: Container(
                                width: 300,
                                height: height*0.07,
                                alignment: Alignment.center,
                                child: Text('로그인',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: colorPallet.textColor,
                                    )
                                )
                            )
                        ),
                      ),
                      SizedBox(height: height*0.01,),
                      Row(
                        children: [
                          TextButton(onPressed: (){}, child: Text('아이디 찾기',
                            style: TextStyle(
                              color: Color(0xffB3B3B3),
                              fontSize: 20,
                              ),
                            )
                          ),
                          Text('|',
                            style: TextStyle(
                                color: Color(0xffB3B3B3),
                              fontSize: 20,
                            )
                          ),
                          TextButton(onPressed: (){}, child: Text('비밀번호 찾기',
                              style: TextStyle(
                                color: Color(0xffB3B3B3),
                                fontSize: 20,
                              )
                            )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}
