import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/SignUpController.dart';
import 'package:atti/screen/LoginSignUp/FinishSignUpScreen.dart';
import 'package:atti/screen/LoginSignUp/SignUpFamilyTag.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final SignUpController signUpController = Get.put(SignUpController());
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? loggedUser;
  String userName = "";
  String userPhoneNumber = "";
  String userPatientEmail = "";
  late String patientDocId;
  DateTime userBirthDate = DateTime.now();
  String formattedDate = "연도 / 월 / 일을 선택해 주세요";
  int isPressed = 0;
  bool _isButtonDisabled = true;

  void updateButtonStatus() {
    setState(() {
      _isButtonDisabled = ((signUpController.isPatient == true) && (userName.length < 2 || formattedDate == "연도 / 월 / 일을 선택해 주세요" || userPhoneNumber.length < 10)) ||
          ((signUpController.isPatient == false) && (userName.length < 2 || userPhoneNumber.length < 10 || !userPatientEmail.contains('@') || !userPatientEmail.contains('.')));
    });
  }

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

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
      };
    }
    catch (e) {
      print(e);
    }
  }

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      minDateTime: DateTime(1900),
      title: '생년월일을 입력해 주세요',
      titleStyle: TextStyle(
        fontSize: 24, fontWeight: FontWeight.normal,
      ),
      dateOrder: DatePickerDateOrder.ymd,
      pickerTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 24,
      ),
      displayCloseIcon: false,
      onSubmit: (value) {
        if (value != null) {
          signUpController.userBirthDate = value; // check
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
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
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
    updateButtonStatus();
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    final userRef = _db.collection("user");

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
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('이름',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 15.0),
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
                                  onChanged: (value) {
                                    signUpController.userName.value = value;
                                    setState(() {
                                      userName = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 2) {
                                      return "2글자 이상을 입력해 주세요";
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      fontSize: 24
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "이름을 입력해주세요",
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        color: colorPallet.textColor,
                                      fontWeight: FontWeight.normal
                                    ),
                                  )
                              ),
                            ),
                            if (isPressed == 1 && userName.length < 2)
                              Container(
                                child: Text(
                                  "2글자 이상의 이름을 입력해 주세요",
                                  style: TextStyle(
                                    color: colorPallet.alertColor,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      // 1 이름
                      if (signUpController.isPatient.value)
                        SizedBox(height: height * 0.05,),
                      if (signUpController.isPatient.value)
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text('생년월일',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24
                            ),
                          ),
                        ),
                      // 생년월일 타이틀
                      if (signUpController.isPatient.value)
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: height*0.01),
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                          decoration: BoxDecoration(
                            color: colorPallet.yellow,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                              color: isPressed == 2? colorPallet.textColor : colorPallet.yellow,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _openDatePicker(context);
                                  setState(() {
                                    isPressed = 2;
                                  });
                                },
                                child: Text("${formattedDate}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: formattedDate == "연도 / 월 / 일을 선택해 주세요" ? colorPallet.textColor : Colors.black,
                                    fontWeight: FontWeight.normal
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // 2 생년월일 입력폼
                      SizedBox(height: height * 0.05,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('전화번호',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),),
                            Container(
                              margin: EdgeInsets.only(top: height*0.01),
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 15.0),
                              decoration: BoxDecoration(
                                color: colorPallet.yellow,
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                  color: isPressed == 3? colorPallet.textColor : colorPallet.yellow,
                                ),
                              ),
                              child: TextFormField(
                                onTap: (){
                                  setState(() {
                                    isPressed = 3;
                                  });
                                },
                                onChanged: (value) {
                                  signUpController.userPhoneNumber.value = value;
                                  setState(() {
                                    userPhoneNumber = value;
                                  });
                                },
                                validator: (value) {
                                  if (value!.length < 10) {
                                    return "유효한 전화번호를 입력해 주세요";
                                  }
                                  return null; // 유효성 검사에 성공한 경우 null 반환
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '01012345678',
                                  hintStyle: TextStyle(
                                      fontSize: 24,
                                      color: colorPallet.textColor,
                                    fontWeight: FontWeight.normal
                                  ),
                                ),
                                onSaved: (value) {
                                  userPhoneNumber = value!;
                                },
                                style: TextStyle(
                                    fontSize: 24
                                ),
                              ),
                            ),
                            if (isPressed == 3 && userPhoneNumber.length < 10)
                              Container(
                                child: Text(
                                  "유효한 전화번호를 입력해 주세요",
                                  style: TextStyle(
                                    color: colorPallet.alertColor,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      // 3 전화번호
                      if (!signUpController.isPatient.value)
                      SizedBox(height: height * 0.05,),
                      if (!signUpController.isPatient.value)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('피보호자 아이디',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: 24
                                ),),
                              Container(
                                margin: EdgeInsets.only(top: height*0.01),
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 5.0, left: 5.0),
                                decoration: BoxDecoration(
                                  color: colorPallet.yellow,
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                    color: isPressed == 4? colorPallet.textColor : colorPallet.yellow,
                                  ),
                                ),
                                child: TextFormField(
                                  onTap: (){
                                    setState(() {
                                      isPressed = 4;
                                    });
                                  },
                                  onChanged: (value) {
                                    signUpController.userPatientEmail.value =
                                        value;
                                    setState(() {
                                      userPatientEmail = value;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty || !value.contains('@')) {
                                      return "유효한 이메일 주소를 입력해 주세요";
                                    }
                                    return null; // 유효성 검사에 성공한 경우 null 반환
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '이메일을 입력해 주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        color: colorPallet.textColor,
                                    ),
                                  ),
                                  onSaved: (value) async {
                                    userPatientEmail = value!;
                                  },
                                  style: TextStyle(
                                      fontSize: 24
                                  ),
                                ),
                              ),
                              if (isPressed == 4 && (!userPatientEmail.contains('@') ||
                                  !userPatientEmail.contains('.')))
                                Container(
                                  child: Text(
                                    "올바른 이메일 형식을 입력해 주세요",
                                    style: TextStyle(
                                      color: colorPallet.alertColor,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      // 4 피보호자 아이디
                      if (signUpController.isPatient.value)
                        SizedBox(height: height * 0.05,),
                      if (signUpController.isPatient.value)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('가족 구성원',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: 24
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
                                    color: isPressed == 5? colorPallet.textColor : colorPallet.yellow,
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
                      SizedBox(height: height * 0.1,),
                      Container(
                        child: ElevatedButton(
                            onPressed: _isButtonDisabled ? null : () async {
                              _tryValidation();
                              try {
                                if (!signUpController.isPatient.value) {
                                  QuerySnapshot snapshot = await _db
                                      .collection('user')
                                      .where('userEmail', isEqualTo: userPatientEmail)
                                      .where('isPatient', isEqualTo: true)
                                      .get();
                                  if (snapshot.docs.length > 0) {
                                    DocumentSnapshot document = snapshot.docs[0];
                                    patientDocId = await (document.data() as Map<String, dynamic>)["userId"];
                                  } else {
                                    print('일치하는 피보호자가 없습니다');
                                    throw ("일치하는 피보호자가 없습니다");
                                  }
                                }
                                print(signUpController.userEmail.value);
                                print(signUpController.userPassword.value);
                                final newUser = await _authentication
                                    .createUserWithEmailAndPassword(
                                    email: signUpController.userEmail.value,
                                    password: signUpController.userPassword
                                        .value);
                                if (newUser.user != null) {
                                  print(newUser.user!.uid);
                                  final Map<String, dynamic> userInfo;
                                  if (signUpController.isPatient.value) {
                                    userInfo = {
                                      "userId": newUser.user!.uid,
                                      "age": signUpController.calculateAge(),
                                      "birthDate": signUpController
                                          .userBirthDate,
                                      "createdAt": DateTime.now(),
                                      "familyMember": signUpController
                                          .userFamily.value,
                                      "isPatient": signUpController.isPatient
                                          .value,
                                      "phoneNumber": signUpController
                                          .userPhoneNumber.value,
                                      "userName": signUpController.userName
                                          .value,
                                      "userEmail": signUpController.userEmail
                                          .value,
                                    };
                                  }
                                  else {
                                    // 환자 search
                                    userInfo = {
                                      "userId": newUser.user!.uid,
                                      "createdAt": DateTime.now(),
                                      "patientDocId": patientDocId,
                                      "isPatient": signUpController.isPatient
                                          .value,
                                      "phoneNumber": signUpController
                                          .userPhoneNumber.value,
                                      "userName": signUpController.userName
                                          .value
                                    };
                                  }
                                  var docRef = await _db
                                      .collection("user")
                                      .add(userInfo);
                                  await docRef.update({ "reference": docRef });
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
                                if (e == "일치하는 피보호자가 없습니다") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text("일치하는 피보호자가 없습니다",
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                _isButtonDisabled ? colorPallet.lightYellow : colorPallet.goldYellow,)
                            ),
                            child: Container(
                                width: 350,
                                height: height * 0.07,
                                alignment: Alignment.center,
                                child: Text('가입하기',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: _isButtonDisabled ? colorPallet.textColor : Colors.white,
                                      fontWeight: FontWeight.bold,
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