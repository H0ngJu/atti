import 'package:flutter/material.dart';
import '../../data/notification/notification_controller.dart';
import '../../data/schedule/schedule_model.dart';
import 'package:atti/data/schedule/schedule_service.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../memory/register/MemoryRegister2.dart';
import '../schedule/ScheduleMain.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:atti/data/memory/memory_note_controller.dart';

class FullScreenSchedule2 extends StatefulWidget {
  const FullScreenSchedule2({super.key, required this.docRef});
  final String docRef;

  @override
  State<FullScreenSchedule2> createState() => _FullScreenSchedule2State();
}

class _FullScreenSchedule2State extends State<FullScreenSchedule2> {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  ScheduleModel? schedule;

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  final MemoryNoteController memoryNoteController = Get.put(MemoryNoteController());

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await firestore
          .collection('schedule')
          .doc(widget.docRef)
          .get();
      if (docSnapshot.exists) {
        schedule = ScheduleModel.fromSnapShot(docSnapshot);
        setState(() {});
      } else {
        print("해당 문서가 존재하지 않습니다.");
      }
    } catch (e) {
      print("데이터를 가져오는 중 에러가 발생했습니다: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String getFormattedTime() {
    DateTime dateTime = schedule?.time?.toDate() ?? DateTime.now();
    var hour = dateTime.hour;
    final minute = dateTime.minute;
    String timeOfDay = '오전';
    if (hour >= 12) {
      timeOfDay = '오후';
      if (hour > 12) hour -= 12;
    }
    return '$timeOfDay ${hour.toString().padLeft(2, '0')}시 ${minute.toString().padLeft(2, '0')}분';
  }

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffFFF7E3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.07,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/logo3.png',
                height: height * 0.04,
                fit: BoxFit.fitWidth),
          ),
          SizedBox(height: height * 0.03,),
          Container(
            alignment: Alignment.center,
            child: Image.asset('lib/assets/Atti/Soccer.png',
                height: height * 0.27,
                fit: BoxFit.fitHeight),
          ),
          SizedBox(height: height * 0.03,),
          TextButton(
            onPressed: () {
            },
            child: Text(getFormattedTime(),
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xffA38130),
                  fontWeight: FontWeight.w500
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xffFFECB5)),
              overlayColor: MaterialStateProperty.all(Colors.transparent), // 클릭 시 효과나 모션 없애기
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              visualDensity: VisualDensity(vertical: -1),
            ),
          ),
          SizedBox(height: height * 0.02,),
          Container(
            width: width * 0.9,
            decoration: BoxDecoration(
                color: Color(0xffFFECB5),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.02,),
                Text('오늘을 기억하기 위해',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                Text('사진을 남길까요?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: height * 0.02,),
                Text('\'${schedule?.name}\'',
                  style: TextStyle(fontSize: 28, color: Color(0xffA38130), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: height * 0.03,),

                SizedBox(
                  width: width * 0.75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(onPressed: () async {
                          await getImage(ImageSource.camera);
                          memoryNoteController.memoryNote.update((val) {
                            val!.img = _image!.path;
                          });
                          Get.to(MemoryRegister2());
                        }, child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('네', style: TextStyle(
                            fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal
                          ),),
                        ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // 모서리를 더 작게 조정
                              ),

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03,),
                      Expanded(
                        child: TextButton(onPressed: () {
                          Get.to(ScheduleMain());
                        }, child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('아니요', style: TextStyle(
                            fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal
                          ),),
                        ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // 모서리를 더 작게 조정
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05,)
              ],
            ),
          )

        ],
      ),
    );
  }
}
