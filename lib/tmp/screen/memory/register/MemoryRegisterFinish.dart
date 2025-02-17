import 'dart:io';

import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_controller.dart';

import '../../../../patient/screen/memory/gallery/MainMemory.dart';

class MemoryRegisterFinish extends StatefulWidget {
  const MemoryRegisterFinish({super.key});

  @override
  State<MemoryRegisterFinish> createState() => _MemoryRegisterFinishState();
}

class _MemoryRegisterFinishState extends State<MemoryRegisterFinish> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    ColorPallet colorPallet = ColorPallet();
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
                  margin: const EdgeInsets.only(left: 15),
                  child: Text('\'${memoryNoteController.tmpImgTitle.value}\'\n기억을 남겼어요!',
                    style: const TextStyle(
                        fontSize: 40, color: Colors.black,
                    ),),
                ),
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
                      : const SizedBox(), // 널일 경우 대체할 위젯 설정
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  child: Text('${memoryNoteController.memoryNote.value.era.toString()}년대',
                    textAlign: TextAlign.left, style: const TextStyle(
                      fontSize: 24,
                    ),),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  child: Text('\'${memoryNoteController.memoryNote.value.imgTitle.toString()}\'',
                    textAlign: TextAlign.left, style: const TextStyle(
                      fontSize: 30,
                    ),),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMemory()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(colorPallet.goldYellow),
                minimumSize: WidgetStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
              child: const Text('내 기억으로 가기', style: TextStyle(color: Colors.black, fontSize: 20),),
            ),
          ),
        ],
      ),
    );
  }
}

