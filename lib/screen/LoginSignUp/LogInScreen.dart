import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
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
                            TextFormField(
                                // onChanged: (value){
                                //   userId = value;
                                // },
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
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "아이디를 입력해 주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xffB3B3B3)
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('비밀번호',
                              style: TextStyle(
                                  fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),),
                            TextFormField(
                                obscureText: true,
                                // onChanged: (value){
                                //   userPw = value;
                                // },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 6) {
                                    return "n글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                // onSaved: (value){
                                //   userPw = value!;
                                // },
                                // keyboardType: TextInputType.emailAddress,
                                // validator: (value) {
                                //   if (value!.isEmpty || !value.contains('@')) {
                                //     return "유효한 이메일 주소를 입력해 주세요";
                                //   }
                                //   return null;
                                // },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "비밀번호를 입력해 주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
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
                              backgroundColor: const Color(0xffFFC215),
                            ),
                            child: Container(
                                width: 350,
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
                      SizedBox(height: 40,),
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
