// 피그마 '기억하기 - 사진 선택' 화면
import 'dart:io';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterAppBar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister2.dart';
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
    ColorPallet colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: MemoryRegisterAppBar(context),
        body: Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    _image != null
                        ? '앨범에서 사진을\n선택했어요':
                          '사진을 추가할 방식을\n선택해주세요',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              _image != null
                   ? Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // 둥근 테두리 설정
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.cover,
                ),
              )
              // ? Container(
                  //     constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                  //     width: MediaQuery.of(context).size.width * 0.9,
                  //     //height: 280,
                  //     child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄움
                  //   )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE0CC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(width*0.05),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('카메라로 사진 찍기', style: TextStyle(fontSize: 24, ),),
                                      Image.asset('lib/assets/images/register_memory_camera.png',
                                        width: width*0.25,),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      SizedBox(height: height * 0.02,),
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: colorPallet.lightYellow,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(width*0.05),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('앨범에서 불러오기', style: TextStyle(fontSize: 24, ),),
                                      Image.asset('lib/assets/images/register_memory_album.png',
                                        width: width*0.25,
                                      ),
                                    ],
                                  ),
                                ),
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
                margin: const EdgeInsets.only(bottom: 20),
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
                              builder: (context) => const MemoryRegister2()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all(const Color(0xffFFC215)),
                        minimumSize: WidgetStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.43, 50)),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all(Colors.white),
                        minimumSize: WidgetStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.43, 50)),
                        side: WidgetStateProperty.all(const BorderSide(
                          color: Colors.black, // 외곽선 색상 설정
                          width: 1, // 외곽선 두께 설정
                        )),
                      ),
                      child: const Text(
                        '다시 선택',
                        style:
                            TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    ));
  }
}
