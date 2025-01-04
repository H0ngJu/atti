// 피그마 '기억하기2 - 사진 제목 입력' 화면
import 'dart:io';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterAppBar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/patient/screen/memory/memory_register/MemoryRegister3.dart';

class MemoryRegister2 extends StatefulWidget {
  const MemoryRegister2({super.key});

  @override
  State<MemoryRegister2> createState() => _MemoryRegister2State();
}

class _MemoryRegister2State extends State<MemoryRegister2> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            DetailPageTitle(
              title: '기억 남기기',
              totalStep: 3,
              currentStep: 1,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.02,),
                    Center(
                      child: Container(
                        //margin: EdgeInsets.only(left: 15),
                        width: MediaQuery.of(context).size.width * 0.9,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '기억 연도를 선택해주세요',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              height: 1.2),
                        ),
                      ),
                    ),
                    SizedBox(height: width * 0.04,),

                    Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: memoryNoteController.memoryNote.value.img != null
                          ? Image.file(
                        File(memoryNoteController.memoryNote.value.img!),
                        fit: BoxFit.cover, // 이미지의 크기를 조정
                        width: MediaQuery.of(context).size.width * 0.9,
                      )
                          : SizedBox(),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        onChanged: (value) {
                          memoryNoteController.memoryNote.value.imgTitle = value;
                        },
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          hintText: '제목으로 무엇이 좋을까요?',
                          hintStyle: TextStyle(fontSize: 24, color:_colorPallet.textColor),
                          filled: true,
                          fillColor: _colorPallet.lightYellow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(15), // 위아래 여백 조절
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            BottomNextButton(content: '다음', next: MemoryRegister3(),
              isEnabled: memoryNoteController.memoryNote.value.imgTitle != null &&
                  memoryNoteController.memoryNote.value.imgTitle!.isNotEmpty,)
          ],
        ),
      ),
    );
  }
}

