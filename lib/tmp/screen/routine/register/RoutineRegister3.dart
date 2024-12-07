import 'package:atti/tmp/screen/routine/register/RoutineRegisterCheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RoutineRegister3 extends StatefulWidget {
  const RoutineRegister3({super.key});

  @override
  State<RoutineRegister3> createState() => _RoutineRegister3State();
}

class _RoutineRegister3State extends State<RoutineRegister3> {
  final RoutineController routineController = Get.put(RoutineController());
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

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
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Column(children: [
            DetailPageTitle(
              title: '일과 등록하기  ',
              description: '해당 일과와 관련된 사진을 \n선택해주세요',
              totalStep: 3, currentStep: 3,
            ),
            SizedBox(height: 30,),
            _image != null
                ? Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
              width: MediaQuery.of(context).size.width * 0.9,
              //height: 280,
                  child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄움
            )
                : GestureDetector(
              onTap: () {
                getImage(ImageSource.gallery);
              },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset(
                    'lib/assets/images/imgpick.png',
                    width: 230,
                    fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],),
          ),
          _image != null
              ? Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    routineController.routine.update((val) {
                      val!.img = _image!.path;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoutineRegisterCheck()),
                    );
                  },
                  child: Text(
                    '다음',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xffFFC215)),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.43, 50)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Text(
                    '다시 선택',
                    style:
                    TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width * 0.43, 50)),
                    side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1.0)),
                  ),
                ),
              ],
            ),
          )
              : SizedBox(),


        ],
      ),
    );
  }
}
