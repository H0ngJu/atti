import 'package:atti/patient/screen/memory/memory_register/MemoryRegister1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
            onPressed: () {
              Get.to(const MemoryRegister1());
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xffFFC215),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
            ),
            child: const Icon(CupertinoIcons.plus, color: Colors.white,size: 40,)
        ),
      );
    }
  }
