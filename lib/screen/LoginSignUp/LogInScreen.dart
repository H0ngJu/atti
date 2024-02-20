import 'package:atti/screen/HomeCarer.dart';
import 'package:atti/screen/HomePatient.dart';
import 'package:atti/screen/LogInSignUp/LogInSignUpMainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:get/get.dart';

import '../../data/auth_controller.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final ColorPallet colorPallet = Get.put(ColorPallet());
  final _authentication = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  late bool isPatient;
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
                                keyboardType: TextInputType.emailAddress,
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
                                  onSaved: (value){
                                    userId = value!;
                                  },
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
                            if (isPressed == 1 && (!userId.contains('@') || !userId.contains('.')))
                              Container(
                                child: Text(
                                  '올바른 이메일 형식을 입력해 주세요',
                                  style: TextStyle(
                                    color: colorPallet.alertColor,
                                  ),
                                ),
                              )
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
                                  onSaved: (value){
                                    userPassword = value!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
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
                            if (isPressed == 2 && userPassword.length < 6)
                              Container(
                                child: Text(
                                  '6글자 이상의 비밀번호를 입력해 주세요',
                                  style: TextStyle(
                                    color: colorPallet.alertColor,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05,),
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (!userId.contains('@') || !userId.contains('.') || userPassword.length < 6) {
                                  throw ("이메일과 비밀번호를 확인해 주세요");
                                }
                                final credential = await _authentication.signInWithEmailAndPassword(
                                  email: userId,
                                  password: userPassword,
                                );
                                if (credential.user != null) {

                                  print(credential.user!.uid);

                                  QuerySnapshot snapshot = await _db
                                      .collection('user')
                                      .where('userId', isEqualTo: credential.user!.uid)
                                      .get();
                                  DocumentSnapshot document = snapshot.docs[0];
                                  isPatient = await (document.data() as Map<String, dynamic>)["isPatient"];

                                  // 사용자 정보 저장
                                  final AuthController authController = Get.put(AuthController());
                                  authController.isPatient = document['isPatient'];
                                  print(authController.userName.value);

                                  if (isPatient) {
                                    authController.patientDocRef = document.reference;
                                    authController.userName.value = document['userName'];
                                    authController.familyMember.value = List<String>.from(document['familyMember']);
                                    print(authController.familyMember.value);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return HomePatient();
                                        }
                                        )
                                    );
                                  }
                                  else {
                                    var patientUid = document['patientDocId'];
                                    QuerySnapshot carerSnapShot = await _db
                                        .collection('user')
                                        .where('userId', isEqualTo: patientUid)
                                        .get();
                                    DocumentSnapshot carerDoc = carerSnapShot.docs[0];
                                    authController.patientDocRef = carerDoc.reference;
                                    authController.userName.value = carerDoc['userName'];
                                    authController.familyMember.value = List<String>.from(carerDoc['familyMember']);
                                    print(authController.familyMember.value);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return HomeCarer();
                                        }
                                        )
                                    );
}
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text('일치하는 아이디가 존재하지 않습니다',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Color(0xffFFC215),
                                      )
                                  );
                                  print('일치하는 아이디가 존재하지 않습니다');
                                } else if (e.code == 'wrong-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text('비밀번호가 일지하지 않습니다',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Color(0xffFFC215),
                                      )
                                  );
                                  print('비밀번호가 일지하지 않습니다.');
                                }
                              }
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
                                      fontWeight: FontWeight.w600,
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
    );
  }
}
