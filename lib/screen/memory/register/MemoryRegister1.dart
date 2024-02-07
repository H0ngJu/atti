// 피그마 '기억하기 - 사진 선택' 화면
import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:image_picker/image_picker.dart';

class MemoryRegister1 extends StatefulWidget {
  const MemoryRegister1({super.key});

  @override
  State<MemoryRegister1> createState() => _MemoryRegister1State();
}

class _MemoryRegister1State extends State<MemoryRegister1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            DetailPageTitle(title: '기억 등록하기', description: '기억할 사진을 선택해주세요', totalStep: 4, currentStep: 1,),

          ],
        ),
      )
    );
  }
}
