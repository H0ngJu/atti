import 'package:atti/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../../data/memory/memory_note_model.dart';
import 'package:atti/data/memory/chatController.dart';
import 'package:atti/patient/screen/memory/chat/ChatComplete.dart';

import '../../../../data/auth_controller.dart';
import '../gallery/MainMemory.dart';

class BeforeSave extends StatelessWidget {
  final MemoryNoteModel memory;
  final String chat;
  final List<MemoryNoteModel> albumList;

  const BeforeSave({Key? key, required this.memory, required this.chat, required this.albumList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatController chatController = ChatController();
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('\'${memory.imgTitle}\' 기억 회상 대화'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        '${memory.img}',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                    )),
                SizedBox(height: 15),
                Text(
                  textAlign: TextAlign.center,
                  '아띠와 나눈 대화를\n기록할까요?',
                  style: TextStyle(
                      fontFamily: 'PretendardRegular', fontSize: 30),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (memory.reference?.path != null) {
                          await chatController.updateChat(
                              chat, memory.reference!.path);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatComplete(memory: memory,albumList: albumList)),
                          );
                        } else {
                          print('Error: memory.reference?.path is null');
                        }
                      },
                      child: Text(
                        '네',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Color(0xffFFC215)),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.4, 60)),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              Size(MediaQuery.of(context).size.width * 0.4, 60)),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.black, width: 1)),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainMemory()),
                        ),
                        child: Text(
                          '아니요',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Atti/default1.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
