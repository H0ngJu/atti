import 'package:atti/screen/HomePatient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/commons/BottomNextButton.dart';

class MemoryRegisterFinish extends StatefulWidget {
  const MemoryRegisterFinish({super.key});

  @override
  State<MemoryRegisterFinish> createState() => _MemoryRegisterFinishState();
}

class _MemoryRegisterFinishState extends State<MemoryRegisterFinish> {
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFEEBC),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(left: 15),
                  child: Text('\'${memoryNoteController.tmpImgTitle.value}\'\n기억을 등록했어요!',
                    style: TextStyle(
                        fontSize: 40, fontWeight: FontWeight.w600, color: Color(0xffA38130)
                    ),),
                ),
                //SizedBox(height: 10,),
                Container(
                  //margin: EdgeInsets.only(left: 50),
                  child: Image.asset('lib/assets/images/memory_atti.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePatient()),
                );
              },
              child: Text('내 기억으로 가기', style: TextStyle(color: Colors.black, fontSize: 20),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                minimumSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width * 0.9, 50)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

