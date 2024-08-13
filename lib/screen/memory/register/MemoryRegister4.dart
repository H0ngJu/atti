// 피그마 '기억하기4 - 키워드 입력' 화면
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/screen/memory/register/MemoryRegisterCheck.dart';

import 'package:material_tag_editor/tag_editor.dart';
import 'package:material_tag_editor/tag_editor_layout_delegate.dart';
import 'package:material_tag_editor/tag_layout.dart';
import 'package:material_tag_editor/tag_render_layout_box.dart';

class MemoryRegister4 extends StatefulWidget {
  const MemoryRegister4({super.key});

  @override
  State<MemoryRegister4> createState() => _MemoryRegister4State();
}

class _MemoryRegister4State extends State<MemoryRegister4> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  List<String> _values = [];

  onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailPageTitle(
                    title: '기억 남기기',
                    description: '\'${memoryNoteController.memoryNote.value.imgTitle}\' 사진에 대한\n정보를 알려주세요!',
                    totalStep: 4, currentStep: 4,
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text('기억 단어를 입력해주세요', textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 24,
                    ),),
                  ),
                  SizedBox(height: 10,),
                  AddKeywordTag(),

                  SizedBox(height: 50,),

                ],
              ),
            )),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text('기억 단어란?', textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20, color: Color(0xff616161), fontWeight: FontWeight.w600,
                ),),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text('사진과 관련된 단어 중 가족 구성원 외의\n인물, 사물, 사건, 배경 등의 단어를 말합니다.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20, color: Color(0xff616161),
                ),),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextButton(
                onPressed: () {
                  memoryNoteController.memoryNote.value.keyword?.addAll(_values);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryRegisterCheck()),);
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
        ),
      ),
    );
  }

  Widget AddKeywordTag() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TagEditor(
          tagSpacing: 10,
          length: _values.length,
          delimiters: [',', ' '],
          hasAddButton: false,
          textStyle: TextStyle(fontSize: 20),
          inputDecoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Color(0xffFFF5DB), width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xffA38130), width: 1)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xffFFF5DB), width: 3)
              ),
              contentPadding: EdgeInsets.only(top: 15, bottom: 10, left: 15),
              filled: true,
              fillColor: Color(0xffFFF5DB),
              hintText: '사진과 관련된 단어를 입력해주세요',
              hintStyle: TextStyle(color: Color(0xffA38130), fontSize: 24, fontWeight: FontWeight.normal)
          ),

          onTagChanged: (newValue) {
            setState(() {
              _values.add(newValue);
            });
          },
          tagBuilder: (context, index) => _Chip(
            index: index,
            label: _values[index],
            onDeleted: onDelete,
          )
      ),
    );
  }

}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5,),
      child: Chip(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffA38130), width: 1),
          borderRadius: BorderRadius.circular(20)
        ),
        labelPadding: const EdgeInsets.only(left: 5.0, right: 5),
        label: Text(label, style: TextStyle(
          fontSize: 20, color: Color(0xffA38130), fontWeight: FontWeight.normal
        ),),
        padding: EdgeInsets.all(5),
        deleteIcon: const Icon(
          Icons.close,
          size: 18,
          color: Color(0xffA38130),
        ),
        onDeleted: () {
          onDeleted(index);
        },
      ),
    );
  }
}