// 피그마 '기억하기4 - 키워드 입력' 화면
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryWordsTag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:material_tag_editor/tag_editor.dart';

import '../../../../../data/memory/memory_note_model.dart';
import 'MemoryEditCheck.dart';

class MemoryEdit3 extends StatefulWidget {
  const MemoryEdit3({super.key, required this.memory});
  final MemoryNoteModel memory;

  @override
  State<MemoryEdit3> createState() => _MemoryEdit3State();
}

class _MemoryEdit3State extends State<MemoryEdit3> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());
  final TextEditingController _memoryWordsController = TextEditingController();
  List<String> _values = [];

  onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  @override
  void initState() {
    _values = widget.memory.keyword!;
    memoryNoteController.memoryNote.value.keyword = _values;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailPageTitle(
              title: '기억 수정하기',
              totalStep: 3,
              currentStep: 3,
              //description: '\'${memoryNoteController.memoryNote.value.imgTitle}\'에 대한\n기억 단어를 알려주세요',
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Center(
                    child: Container(
                      //margin: EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '\'${memoryNoteController.memoryNote.value.imgTitle}\'에 대한\n기억 단어를 알려주세요',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            height: 1.2),
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.04,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    margin: EdgeInsets.symmetric(horizontal: width*0.05),
                    decoration: BoxDecoration(
                      color: colorPallet.lightYellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            child: TextField(
                              controller: _memoryWordsController,
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '단어를 입력해주세요',
                                hintStyle: TextStyle(
                                    color: Color(0xff745C20),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: width * 0.16,
                          height: width * 0.09,
                          child: TextButton(
                            onPressed: () {
                              String memberName = _memoryWordsController.text;
                              if (memberName.isNotEmpty) {
                                setState(() {
                                  memoryNoteController.memoryNote.value.keyword?.add(memberName);
                                  _memoryWordsController.clear(); // 입력 필드 비우기
                                });
                              }
                              //memoryNoteController.memoryNote.value.keyword?.addAll(_values);
                              print(memoryNoteController.memoryNote.value.keyword);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryRegisterCheck()),);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: _memoryWordsController.text.isNotEmpty ?
                              colorPallet.goldYellow :
                              Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            ),
                            child: const Text(
                              '등록',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: width * 0.06),
                  SizedBox(
                    width: width * 0.9,
                    child: Text(
                      '등록한 단어',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: colorPallet.grey
                      ),
                    ),
                  ),

                  SizedBox(
                    width: width * 0.9,
                    child: Wrap(
                      spacing: 8.0,
                      children: memoryNoteController.memoryNote.value.keyword!.map((member) {
                        return MemoryWordsTag(
                          name: member,
                          onDelete: () {
                            setState(() {
                              memoryNoteController.memoryNote.value.keyword!.remove(member);

                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 50,),

                ],
              ),
            )),
            Container(
              margin: const EdgeInsets.only(left: 15),
              //width: MediaQuery.of(context).size.width * 0.9,
              //alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff616161), // 밑줄 색상
                    width: 1, // 밑줄 두께
                  ),
                ),
              ),
              child: const Text(
                '기억 단어란?',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  height: 1.0
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              child: const Text('사진과 관련된 단어로\n기억하고 싶은 인물이나 사물, 사건, 배경 등의\n단어를 말합니다.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18, color: Colors.black,
                ),),
            ),
            const SizedBox(height: 20,),
            BottomNextButton(next: MemoryEditCheck(memory: widget.memory), content: '다음', isEnabled: true),
          ],
        ),
      ),
    );
  }

  Widget AddKeywordTag() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TagEditor(
          tagSpacing: 10,
          length: _values.length,
          delimiters: const [',', ' '],
          hasAddButton: false,
          textStyle: const TextStyle(fontSize: 20),
          inputDecoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xffFFF5DB), width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xffA38130), width: 1)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xffFFF5DB), width: 3)
              ),
              contentPadding: const EdgeInsets.only(top: 15, bottom: 10, left: 15),
              filled: true,
              fillColor: const Color(0xffFFF5DB),
              hintText: '기억 단어를 입력해주세요',
              hintStyle: const TextStyle(color: Color(0xffA38130), fontSize: 24, fontWeight: FontWeight.normal)
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
      padding: const EdgeInsets.only(top: 5,),
      child: Chip(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffA38130), width: 1),
          borderRadius: BorderRadius.circular(20)
        ),
        labelPadding: const EdgeInsets.only(left: 5.0, right: 5),
        label: Text(label, style: const TextStyle(
          fontSize: 20, color: Color(0xffA38130), fontWeight: FontWeight.normal
        ),),
        padding: const EdgeInsets.all(5),
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