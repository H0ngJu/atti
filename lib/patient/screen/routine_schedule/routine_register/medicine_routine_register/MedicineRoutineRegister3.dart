import 'package:atti/commons/YesNoActionButtons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atti/data/routine/routine_controller.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../../commons/colorPallet.dart';
import 'MedicineRoutineRegisterCheck.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MidicineRoutineRegister3 extends StatefulWidget {
  const MidicineRoutineRegister3({super.key});

  @override
  State<MidicineRoutineRegister3> createState() => _MidicineRoutineRegister3State();
}

class _MidicineRoutineRegister3State extends State<MidicineRoutineRegister3> {
  final RoutineController routineController = Get.put(RoutineController());
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  final ColorPallet colorPallet = Get.put(ColorPallet());

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

  //
  Future<String> getAssetFilePath(String assetPath) async {
    // 앱의 임시 디렉토리 가져오기
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/${assetPath.split('/').last}';

    // 애셋 파일 읽기
    final byteData = await rootBundle.load(assetPath);

    // 임시 디렉토리에 파일 쓰기
    final file = File(tempPath);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const DetailPageTitle(
                  title: '복약 일과 등록하기',
                  description: '복약하실 약 또는 관련 사진을\n선택해주세요',
                  totalStep: 3,
                  currentStep: 3,
                ),
                SizedBox(
                  height: width * 0.06,
                ),

                _image != null
                    ? Container(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.4),
                        width: MediaQuery.of(context).size.width * 0.9,
                        //height: 280,
                        child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄움
                      )
                    : GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Image.asset(
                            'lib/assets/images/imgpick.png',
                            width: 230,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),

                GestureDetector(
                  onTap: () async {
                    // Asset 파일 경로 가져오기
                    final defaultImagePath = await getAssetFilePath('lib/assets/images/routine_default.png');

                    setState(() {
                      routineController.routine.update((val) {
                        val!.img = defaultImagePath; // 변환된 파일 경로 저장
                      });

                      _image = XFile(defaultImagePath); // XFile 객체 생성

                      Get.to(const MedicineRoutineRegisterCheck());
                    });
                  },
                  child: Align(
                    alignment: Alignment.centerRight, // 텍스트를 오른쪽 정렬
                    child: Padding(
                      padding:  const EdgeInsets.only(right: 15),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: colorPallet.grey,
                            ),
                          ),
                        ),
                        child: Text(
                          '사진 생략',
                          style: TextStyle(
                            fontSize: 20,
                            color: colorPallet.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          _image != null
              ? YesNoActionButtons(
                  primaryText: '다음',
                  secondaryText: '다시 선택',
                  onPrimaryPressed: () {
                    routineController.routine.update((val) {
                      val!.img = _image!.path;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MedicineRoutineRegisterCheck()),
                    );
                  },
                  onSecondaryPressed: () {
                    getImage(ImageSource.gallery);
                  })
              : const SizedBox(),
        ],
      ),
    );
  }
}
