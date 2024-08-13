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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              DetailPageTitle(
                title: '기억 남기기',
                description: '기억할 사진을 선택해주세요',
                totalStep: 4,
                currentStep: 1,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              _image != null
                  ? Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                      width: MediaQuery.of(context).size.width * 0.9,
                      //height: 280,
                      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄움
                    )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.06,),
                                Text('카메라', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
                                SizedBox(height: height * 0.02,),
                                Text('지금 사진을\n찍을까요?',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: height * 0.07,),
                              ],
                            )
                          ),
                        ),
                      SizedBox(width: width * 0.03,),
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.06,),
                                Text('갤러리', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
                                SizedBox(height: height * 0.02,),
                                Text('찍어둔 사진이\n있나요?',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: height * 0.07,),
                              ],
                            )
                        ),
                      ),



                    ],
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
                        Navigator.pop(context);
                      },
                      child: Text(
                        '다시 선택',
                        style:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.43, 50)),
                        side: MaterialStateProperty.all(BorderSide(
                          color: Colors.black, // 외곽선 색상 설정
                          width: 1, // 외곽선 두께 설정
                        )),
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
