// 피그마 '기억하기 - 사진 선택' 화면
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/screen/memory/register/MemoryRegister2.dart';

class MemoryRegister1 extends StatefulWidget {
  const MemoryRegister1({super.key});

  @override
  State<MemoryRegister1> createState() => _MemoryRegister1State();
}

class _MemoryRegister1State extends State<MemoryRegister1> {
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
              DetailPageTitle(title: '기억하기', description: '기억할 사진을 선택해주세요',
              totalStep: 4,
              currentStep: 1,),
            SizedBox(height: 30,),

            _image != null
                ? Container(
                  width: 300,
                  height: 300,
                  child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
                )
                : GestureDetector(
              onTap: (){
                getImage(ImageSource.gallery);
              },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset('lib/assets/images/imgpick.png',
                  width: 230,
                  fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
          ),
          NextButton(next: MemoryRegister2(), content: '다음', isEnabled: true)

        ],
      ));
  }
}
