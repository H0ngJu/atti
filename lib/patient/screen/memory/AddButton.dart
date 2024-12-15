import 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
            onPressed: () {
              Get.to(MemoryRegister1());
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color(0xffFFC215),
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
            child: Icon(CupertinoIcons.plus, color: Colors.white,size: 40,)
        ),
      );
    }
  }
