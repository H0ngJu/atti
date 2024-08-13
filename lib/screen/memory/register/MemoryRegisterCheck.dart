// 피그마 '기억하기5 - 등록 확인' 화면
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/screen/memory/register/MemoryRegisterFinish.dart';

class MemoryRegisterCheck extends StatefulWidget {
  const MemoryRegisterCheck({super.key});

  @override
  State<MemoryRegisterCheck> createState() => _MemoryRegisterCheckState();
}

class _MemoryRegisterCheckState extends State<MemoryRegisterCheck> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    final List<String> keywords = memoryNoteController.memoryNote.value.keyword ?? [];

    return Scaffold(
        backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                DetailPageTitle(
                  title: '기억 남기기',
                  description: '다음과 같이 등록할까요?',
                  totalStep: 0, currentStep: 0,
                ),
                SizedBox(height: 20,),

                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text('${memoryNoteController.memoryNote.value.era.toString()}년대',
                    textAlign: TextAlign.left, style: TextStyle(
                    fontSize: 24,
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text(memoryNoteController.memoryNote.value.imgTitle.toString(),
                    textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 30,
                    ),),
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: memoryNoteController.memoryNote.value.img != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(30), // 모서리를 30만큼 둥글게 설정
                        child: Image.file(File(memoryNoteController.memoryNote.value.img!)),
                  )
                      : SizedBox(), // 널일 경우 대체할 위젯 설정
                ),

                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text('기억 단어',
                    textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 24,
                    ),),
                ),
                SizedBox(height: 10,),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15),
                    child: MemoryKeyword(keywords: keywords)),
                SizedBox(height: 30,),


              ],
            ),
          )),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                memoryNoteController.tmpImgTitle.value = memoryNoteController.memoryNote.value.imgTitle!;
                memoryNoteController.addMemoryNote();


                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemoryRegisterFinish()),
                );
              },
              child: Text('등록', style: TextStyle(color: Colors.white, fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class MemoryKeyword extends StatelessWidget {
  const MemoryKeyword({super.key, this.keywords});
  final keywords;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 10, // 가로 간격 설정
      runSpacing: 10, // 세로 간격 설정
      children: List.generate(keywords.length ?? 0, (index) {
        return TextButton(
          onPressed: () {
          },
          child: Text(keywords[index], style: TextStyle(
            fontSize: 24, color: Color(0xffA38130), fontWeight: FontWeight.normal
          ),),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffFFF5DB)),
            overlayColor: MaterialStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
          ),
        );
      }).toList(),
    );
  }
}
