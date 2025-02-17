import 'dart:io';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegisterAppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemoryRegister5 extends StatefulWidget {
  const MemoryRegister5({super.key});

  @override
  State<MemoryRegister5> createState() => _MemoryRegister5State();
}

class _MemoryRegister5State extends State<MemoryRegister5> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ColorPallet colorPallet = ColorPallet();

    return Scaffold(
        appBar: MemoryRegisterAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: const Text('다음과 같이 등록할까요?', textAlign: TextAlign.left, style: TextStyle(
                  fontSize: 30,
                ),),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerLeft,
                child: const Column(
                  children: [
                    // Text('${memoryNoteController.}', textAlign: TextAlign.left, style: TextStyle(
                    //   fontSize: 30,
                    // ),),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(maxHeight: height * 0.35),
                width: width * 0.6,
                child: memoryNoteController.memoryNote.value.img != null
                    ? Image.file(
                        File(memoryNoteController.memoryNote.value.img!),
                          fit: BoxFit.cover,
                        )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
    );
  }
}
