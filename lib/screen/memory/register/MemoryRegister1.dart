// 피그마 '기억하기 - 사진 선택' 화면
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:atti/screen/memory/register/MemoryRegister2.dart';
import 'package:atti/data/memory/memory_note_controller.dart';

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

  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              DetailPageTitle(
                title: '기억하기',
                description: '기억할 사진을 선택해주세요',
                totalStep: 4,
                currentStep: 1,
              ),
              SizedBox(
                height: 30,
              ),
              _image != null
                  ? Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                      width: MediaQuery.of(context).size.width * 0.9,
                      //height: 280,
                      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄움
                    )
                  : GestureDetector(
                      onTap: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Image.asset(
                          'lib/assets/images/imgpick.png',
                          width: 230,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            ],
          ),
        ),
        _image != null
            ? Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        memoryNoteController.memoryNote.update((val) {
                          val!.img = _image!.path;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MemoryRegister2()),
                        );
                      },
                      child: Text(
                        '다음',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFFC215)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.43, 50)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Text(
                        '다시 선택',
                        style:
                            TextStyle(color: Color(0xffA38130), fontSize: 20),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFFF5DB)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.43, 50)),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    ));
  }
}
