import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/SignUpController.dart';
import 'package:atti/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignUpScreen3 extends StatefulWidget {
  SignUpScreen3({super.key});

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final SignUpController signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  String userName = "";
  DateTime userBirthDate = DateTime.now();
  late String formattedDate = DateFormat('yyyy년 MM월 dd일').format(userBirthDate);

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null){
        loggedUser = user;
      };
    }
    catch (e) {
      print(e);
    }
  }
  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      title: '생년월일을 입력해 주세요',
      dateOrder: DatePickerDateOrder.ymd,
      pickerTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 24,
      ),
      onSubmit: (value) {
        if (value != null) {
          signUpController.userBirthDate = value; // check
          setState(() {
            userBirthDate = value;
            formattedDate = DateFormat('yyyy년 MM월 dd일').format(userBirthDate);
          });
        }
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: (){
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
              margin: EdgeInsets.only(top: height*0.2, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이름',
                              style: TextStyle(
                                  fontSize: 24
                              ),),
                            TextFormField(
                                onChanged: (value){
                                  signUpController.userName.value = value;
                                  setState(() {
                                    userName = value;
                                  });
                                },
                                validator: (value){
                                  if (value!.isEmpty || value.length < 2) {
                                    return "2글자 이상을 입력해 주세요";
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "이름을 입력해주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: Color(0xffB3B3B3)
                                  ),
                                  errorText: userName.length < 2 ? '2글자 이상의 이름을 입력해 주세요' : null,
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05,),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('생년월일',
                          style: TextStyle(
                              fontSize: 24
                          ),),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                               onPressed: () { _openDatePicker(context);},
                               child: Text("${formattedDate}",
                                   style: TextStyle(
                                     fontSize: 30,
                                     color: Color(0xffB3B3B3),
                                   ),
                               ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('가족 구성원',
                              style: TextStyle(
                                  fontSize: 24
                              ),
                            ),
                            TextFormField(
                                onSaved: (value){
                                  signUpController.userFamily.value = value.toString().split(" ");
                                },
                                style: TextStyle(
                                    fontSize: 30
                                ),
                                decoration: InputDecoration(
                                  hintText: "구성원의 이름을 입력해주세요",
                                  hintStyle: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xffB3B3B3)
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 100,),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                                _tryValidation();
                                try {
                                  print(signUpController.userEmail.value);
                                  print(signUpController.userPassword.value);
                                  final newUser = await _authentication.createUserWithEmailAndPassword(
                                      email: signUpController.userEmail.value,
                                      password: signUpController.userPassword.value);
                                  if (newUser.user != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return FinishSignUpScreen();
                                        }
                                        )
                                    );
                                  }
                                }
                                catch (e) {
                                  print("에러:");
                                  print(e);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text('이메일 또는 패스워드를 확인해 주세요',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Color(0xffFFC215),
                                      )
                                  );
                                }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFFC215),
                            ),
                            child: Container(
                                width: 350,
                                height: height*0.07,
                                alignment: Alignment.center,
                                child: Text('가입하기',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: const Color(0xff000000),
                                    )
                                )
                            )
                        ),
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

