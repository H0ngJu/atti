import 'package:atti/commons/Tag.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/signup_login/SignUpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoEditPage extends StatefulWidget {
  const UserInfoEditPage({super.key});

  @override
  State<UserInfoEditPage> createState() => _UserInfoEditPageState();
}

class _UserInfoEditPageState extends State<UserInfoEditPage> {
  AuthController _authController = Get.find<AuthController>();
  SignUpController _signUpController = Get.put(SignUpController());

  ColorPallet _colorPallet = ColorPallet();

  // TextEditingController 추가
  TextEditingController _familyMemberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String userName = _authController.userName.value;
    String birthDate = _authController.birthDate;
    List<String> familyMembers = _authController.familyMember.value;

    String formatDate(String date) {
      List<String> parts = date.split('.');

      if (parts.length != 3) {
        return '잘못된 날짜 형식';
      }

      String year = parts[0];
      String month = parts[1];
      String day = parts[2];

      return '$year년 $month월 $day일';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '나의 정보 수정',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('이름', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: _colorPallet.lightYellow,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: userName,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('생년월일', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  fillColor: _colorPallet.lightYellow,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: formatDate(birthDate),
                ),
              ),
              SizedBox(height: 16),
              Text('가족 및 친한 지인', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _colorPallet.lightYellow,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(

                        child: TextField(
                          controller: _familyMemberController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '이름을 입력해주세요',
                            hintStyle: TextStyle(color: _colorPallet.khaki, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String memberName = _familyMemberController.text;
                        if (memberName.isNotEmpty) {
                          setState(() {
                            familyMembers.add(memberName);
                            _familyMemberController.clear(); // 입력 필드 비우기
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _familyMemberController.text.isNotEmpty ? _colorPallet.goldYellow : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                      ),
                      child: Text(
                        '등록',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: familyMembers.map((member) {
                  return Tag(name: member);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
