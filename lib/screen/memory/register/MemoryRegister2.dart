// 피그마 '기억하기2 - 사진 제목 입력' 화면
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';

class MemoryRegister2 extends StatefulWidget {
  const MemoryRegister2({super.key});

  @override
  State<MemoryRegister2> createState() => _MemoryRegister2State();
}

class _MemoryRegister2State extends State<MemoryRegister2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DetailPageTitle(title: '기억하기', description: '사진 제목을 입력해주세요', totalStep: 4, currentStep: 2,),

        ],
      ),
    );
  }
}

