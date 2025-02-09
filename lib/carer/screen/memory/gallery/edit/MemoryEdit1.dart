// 피그마 '기억하기2 - 사진 제목 입력' 화면
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:atti/commons/BottomNextButton.dart';
import 'package:atti/data/memory/memory_note_controller.dart';

import '../../../../../data/memory/memory_note_model.dart';
import 'MemoryEdit2.dart';

class MemoryEdit1 extends StatefulWidget {
  const MemoryEdit1({super.key, required this.memory});
  final MemoryNoteModel memory;

  @override
  State<MemoryEdit1> createState() => _MemoryEdit1State();
}

class _MemoryEdit1State extends State<MemoryEdit1> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  void initState() {
    super.initState();
    memoryNoteController.memoryNote.value.img = widget.memory.img;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet colorPallet = ColorPallet();

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const DetailPageTitle(
              title: '기억 수정하기',
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
                        child: const Text(
                          '기억 제목을 입력해주세요',
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
                          ? Image.network(
                        memoryNoteController.memoryNote.value.img!,
                        fit: BoxFit.cover, // 이미지의 크기를 조정
                        width: MediaQuery.of(context).size.width * 0.9,
                      )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        onChanged: (value) {
                          memoryNoteController.memoryNote.value.imgTitle = value;
                        },
                        cursorColor: Colors.black,
                        style: const TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          hintText: widget.memory.imgTitle,
                          hintStyle: TextStyle(fontSize: 24, color:colorPallet.textColor, fontWeight: FontWeight.w400),
                          filled: true,
                          fillColor: colorPallet.lightYellow,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(15), // 위아래 여백 조절
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            BottomNextButton(content: '다음', next: MemoryEdit2(memory: widget.memory),
              isEnabled: memoryNoteController.memoryNote.value.imgTitle != null &&
                  memoryNoteController.memoryNote.value.imgTitle!.isNotEmpty,)
          ],
        ),
      ),
    );
  }
}

