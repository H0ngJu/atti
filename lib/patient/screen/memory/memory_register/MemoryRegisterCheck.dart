// 피그마 '기억하기5 - 등록 확인' 화면
import 'dart:io';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/patient/screen/memory/memory_register/MemoryRegisterFinish.dart';

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
    final List<String> people = memoryNoteController.memoryNote.value.selectedFamilyMember ?? [];
    ColorPallet _colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: MemoryRegisterAppBar(context),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text('다음과 같이 등록할까요?', textAlign: TextAlign.left, style: TextStyle(
                    fontSize: 30,
                  ),),
                ),
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
                  child: Text('\'${memoryNoteController.memoryNote.value.imgTitle.toString()}\'',
                    textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 30,
                    ),),
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: memoryNoteController.memoryNote.value.img != null
                      ? Image.file(
                      File(memoryNoteController.memoryNote.value.img!),
                    fit: BoxFit.cover, // 이미지의 크기를 조정
                    width: MediaQuery.of(context).size.width * 0.7,
                  )
                      : SizedBox(), // 널일 경우 대체할 위젯 설정
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  child: Text('함께한 사람',
                    textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 24,
                    ),),
                ),
                SizedBox(height: 10,),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 15),
                    child: MemoryPeople(keywords: people)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                  child: Text('등록', style: TextStyle(color: Colors.black, fontSize: 20),),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(_colorPallet.orange),
                    minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.425, 50)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextButton(
                  onPressed: () {
                    memoryNoteController.tmpImgTitle.value = memoryNoteController.memoryNote.value.imgTitle!;
                    memoryNoteController.addMemoryNote();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MemoryRegister1()),
                    );
                  },
                  child: Text('수정', style: TextStyle(color: Colors.black, fontSize: 20),),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Colors.black,
                          width: 1,
                        ),
                    )),
                    minimumSize: WidgetStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.425, 50)),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

class MemoryPeople extends StatelessWidget {
  final keywords;
  const MemoryPeople({super.key, this.keywords});

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
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal
          ),),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            overlayColor: WidgetStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            )),
          ),
        );
      }).toList(),
    );
  }
}


class MemoryKeyword extends StatelessWidget {
  const MemoryKeyword({super.key, this.keywords});
  final keywords;

  @override
  Widget build(BuildContext context) {
    ColorPallet _colorPallet = ColorPallet();
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
            fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal
          ),),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(_colorPallet.lightYellow),
            overlayColor: WidgetStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
          ),
        );
      }).toList(),
    );
  }
}
