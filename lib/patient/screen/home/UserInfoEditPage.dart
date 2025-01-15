import 'package:atti/commons/Tag.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/auth_controller.dart';
import 'package:atti/data/userinfo/UserInfoUpdateController.dart';
import 'package:atti/patient/screen/home/Menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoEditPage extends StatefulWidget {
  const UserInfoEditPage({super.key});

  @override
  State<UserInfoEditPage> createState() => _UserInfoEditPageState();
}

class _UserInfoEditPageState extends State<UserInfoEditPage> {
  AuthController _authController = Get.find<AuthController>();
  UserInfoUpdateController _userInfoUpdateController = Get.put(UserInfoUpdateController());

  ColorPallet _colorPallet = ColorPallet();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _familyMemberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _authController.userName.value;
    _birthDateController.text = _authController.birthDate;
    _userInfoUpdateController.fetchUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _familyMemberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
              Text('이름', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  fillColor: _colorPallet.lightYellow,
                  filled: true,
                  hintStyle: TextStyle(fontSize: 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: userName,
                ),
              ),
              SizedBox(height: 16),
              Text('생년월일', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              TextField(
                controller: _birthDateController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 24),
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
              Text('가족 및 친한 지인', style: TextStyle(fontSize: 24)),
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
                      child: TextField(
                        controller: _familyMemberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '이름을 입력해주세요',
                          hintStyle: TextStyle(color: _colorPallet.khaki, fontSize: 24),
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
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: familyMembers.map((member) {
                  return Tag(
                    name: member,
                    onDelete: () {
                      setState(() {
                        familyMembers.remove(member); // 리스트에서 해당 원소 삭제
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: height*0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: width*0.4,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(_colorPallet.goldYellow),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // 모서리 둥글기
                        )),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              contentPadding: EdgeInsets.all(20),
                              content: Container(
                                height: height*0.5,
                                width: width*0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '회원정보가 수정됩니다.\n정말 수정하시겠습니까?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width*0.3,
                                          child: TextButton(
                                            onPressed: () {
                                              // Firebase에 내용 업데이트하는 로직
                                              _userInfoUpdateController.userName.value = _nameController.text;
                                              // _userInfoUpdateController.userBirthDate = userName; // 다시 보기 ....
                                              _userInfoUpdateController.userFamily.value = familyMembers;

                                              _userInfoUpdateController.updateUserInfo();

                                              _authController.userName.value = _nameController.text;
                                              // _authController.birthDate.value = _birthDateController;
                                              _authController.familyMember.value = familyMembers;

                                              Navigator.of(context).pop();
                                              // Menu()로 이동
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(builder: (context) => Menu()),
                                                    (Route<dynamic> route) => false,
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _colorPallet.goldYellow,
                                            ),
                                            child: Text('네', style: TextStyle(color: Colors.black,
                                            fontSize: 24),),
                                          ),
                                        ),
                                        Container(
                                          width: width*0.3,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                              side: WidgetStateProperty.all(BorderSide(
                                                color: Colors.black, // 보더 색상
                                                width: 1.0, // 보더 두께
                                              )),
                                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30), // 모서리 둥글기
                                              )),
                                            ),
                                            child: Text('아니요',
                                              style: TextStyle(color: Colors.black,
                                              fontSize: 24),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('수정',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width*0.4,
                    child: TextButton(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide(
                          color: Colors.black, // 보더 색상
                          width: 1.0, // 보더 두께
                        )),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // 모서리 둥글기
                        )),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              contentPadding: EdgeInsets.all(20),
                              content: Container(
                                height: height*0.5,
                                width: width*0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '수정한 내용이 사라집니다.\n정말 수정을 취소하시겠습니까?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width*0.3,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: _colorPallet.goldYellow,
                                            ),
                                            child: Text('네', style: TextStyle(color: Colors.black,
                                                fontSize: 24),),
                                          ),
                                        ),
                                        Container(
                                          width: width*0.3,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ButtonStyle(
                                              side: WidgetStateProperty.all(BorderSide(
                                                color: Colors.black, // 보더 색상
                                                width: 1.0, // 보더 두께
                                              )),
                                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30), // 모서리 둥글기
                                              )),
                                            ),
                                            child: Text('아니요',
                                              style: TextStyle(color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text('취소',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
