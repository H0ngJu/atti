// 피그마 '기억하기2 - 사진 제목 입력' 화면
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/screen/memory/register/MemoryRegister3.dart';

class MemoryRegister2 extends StatefulWidget {
  const MemoryRegister2({super.key});

  @override
  State<MemoryRegister2> createState() => _MemoryRegister2State();
}

class _MemoryRegister2State extends State<MemoryRegister2> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DetailPageTitle(title: '기억 남기기', description: '사진 제목을 입력해주세요', totalStep: 4, currentStep: 2,),
                    SizedBox(height: 30,),
                    Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: memoryNoteController.memoryNote.value.img != null
                          ? Image.file(File(memoryNoteController.memoryNote.value.img!))
                          : SizedBox(), // 널일 경우 대체할 위젯 설정
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
                          hintText: '사진 제목으로 무엇이 좋을까요?',
                          hintStyle: TextStyle(fontSize: 24, color: Color(0xffA38130)),
                          filled: true, // 배경을 채움
                          fillColor: Color(0xffFFF5DB),
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
            NextButton(content: '다음', next: MemoryRegister3(),
              isEnabled: memoryNoteController.memoryNote.value.imgTitle != null &&
                  memoryNoteController.memoryNote.value.imgTitle!.isNotEmpty,)
          ],
        ),
      ),
    );
  }
}

