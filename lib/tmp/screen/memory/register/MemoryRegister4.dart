// 피그마 '기억하기4 - 키워드 입력' 화면
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterAppBar.dart';
import 'package:atti/tmp/screen/memory/register/MemoryWordsTag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterCheck.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister5.dart';

class MemoryRegister4 extends StatefulWidget {
  const MemoryRegister4({super.key});

  @override
  State<MemoryRegister4> createState() => _MemoryRegister4State();
}

class _MemoryRegister4State extends State<MemoryRegister4> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  TextEditingController _memoryWordsController = TextEditingController();
  List<String> _values = [];

  onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  @override
  void initState() {
    memoryNoteController.memoryNote.value.keyword = [];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            DetailPageTitle(
              title: '기억 남기기',
              totalStep: 3,
              currentStep: 3,
              description: '\'${memoryNoteController.memoryNote.value.imgTitle}\'에 대한\n기억 단어를 알려주세요',
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: width*0.05),
                    decoration: BoxDecoration(
                      color: _colorPallet.lightYellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: _memoryWordsController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '단어를 입력해주세요',
                                hintStyle: TextStyle(color: _colorPallet.khaki, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            String memberName = _memoryWordsController.text;
                            if (memberName.isNotEmpty) {
                              setState(() {
                                _values.add(memberName);
                                _memoryWordsController.clear(); // 입력 필드 비우기
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _memoryWordsController.text.isNotEmpty ? _colorPallet.goldYellow : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          ),
                          child: Text(
                            '등록',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: _values.map((member) {
                      return MemoryWordsTag(name: member);
                    }).toList(),
                  ),
                  SizedBox(height: 50,),

                ],
              ),
            )),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text('기억단어란?', textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20, color: Color(0xff616161), fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                ),),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: Text('사진과 관련된 단어 중 가족 구성원 외의\n인물, 사물, 사건, 배경 등의 단어를 말합니다.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18, color: Color(0xff616161),
                ),),
            ),
            SizedBox(height: 20,),
            BottomNextButton(next: MemoryRegisterCheck(), content: '다음', isEnabled: true),
            // Container(
            //   margin: EdgeInsets.only(bottom: 20),
            //   child: TextButton(
            //     onPressed: () {
            //       memoryNoteController.memoryNote.value.keyword?.addAll(_values);
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryRegisterCheck()),);
            //     },
            //     child: Text('등록', style: TextStyle(color: Colors.white, fontSize: 20),),
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
            //       minimumSize: MaterialStateProperty.all(
            //           Size(MediaQuery.of(context).size.width * 0.9, 50)),
            //     ),
            //   ),
            // ),
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
              hintText: '기억 단어를 입력해주세요',
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