import 'dart:io';

import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/HomePatient.dart';
import 'package:atti/tmp/screen/memory/gallery/MainGallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/commons/BottomNextButton.dart';

import '../../../../../data/auth_controller.dart';
import '../../../../../patient/screen/memory/gallery/MainMemory.dart';
import '../CarerMainMemory.dart';


class MemoryEditFinish extends StatefulWidget {
  const MemoryEditFinish({super.key});

  @override
  State<MemoryEditFinish> createState() => _MemoryEditFinishState();
}

class _MemoryEditFinishState extends State<MemoryEditFinish> {
  final MemoryNoteController memoryNoteController =
      Get.put(MemoryNoteController());
  final AuthController authController = Get.put(AuthController());


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    '\'${memoryNoteController.tmpImgTitle.value}\'\n기억을 남겼어요!',
                    style: TextStyle(
                        fontSize: 40, color: Colors.black, height: 1.2),
                  ),
                ),

                // 이미지
                Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  width: MediaQuery.of(context).size.width * 0.72,
                  child: memoryNoteController.memoryNote.value.img != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20), // 둥근 테두리 설정
                          child: Image.file(
                            File(memoryNoteController.memoryNote.value.img!),
                            fit: BoxFit.cover, // 이미지의 크기를 조정
                            width: MediaQuery.of(context).size.width * 0.72,
                          ),
                        )
                      : SizedBox(), // 널일 경우 대체할 위젯 설정
                ),

                Container(
                  //margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  child: Text(
                    '${memoryNoteController.memoryNote.value.era.toString()}년대',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  //margin: EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  child: Text(
                    '\'${memoryNoteController.memoryNote.value.imgTitle.toString()}\'',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 30, height: 1.0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20, left: width * 0.05),
            child: TextButton(
              onPressed: () {
                if (authController.isPatient) {
                  Get.to(() => MainMemory());
                } else {
                  Get.to(() => CarerMainMemory());
                }
              },
              child: Text(
                '내 기억으로 가기',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(_colorPallet.goldYellow),
                minimumSize: WidgetStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
