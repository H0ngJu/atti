import 'package:flutter/material.dart';
import '../../../../data/memory/memory_note_model.dart';
import 'package:atti/data/memory/chatController.dart';
import 'package:atti/tmp/screen/memory/chat/ChatComplete.dart';

import '../../../../patient/screen/memory/gallery/MainMemory.dart';

class BeforeSave extends StatelessWidget {
  final MemoryNoteModel memory;
  final String chat;

  const BeforeSave({Key? key, required this.memory, required this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatController chatController = ChatController();

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('\'${memory.imgTitle}\' 기억 회상 대화'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.1),
                Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        '${memory.img}',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                    )),
                const SizedBox(height: 15),
                const Text(
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
                                builder: (context) => TmpChatComplete(memory: memory,)),
                          );
                        } else {
                          print('Error: memory.reference?.path is null');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all(const Color(0xffFFC215)),
                        minimumSize: WidgetStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.4, 60)),
                      ),
                      child: const Text(
                        '네',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      child: TextButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                              Size(MediaQuery.of(context).size.width * 0.4, 60)),
                          backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                          side: WidgetStateProperty.all(
                              const BorderSide(color: Colors.black, width: 1)),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MainMemory()),
                        ),
                        child: const Text(
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Atti/default1.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
