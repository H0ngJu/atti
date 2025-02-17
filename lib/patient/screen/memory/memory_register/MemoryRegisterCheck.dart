// 피그마 '기억하기5 - 등록 확인' 화면
import 'dart:io';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/tmp/screen/memory/register/MemoryRegister1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/memory/memory_note_controller.dart';
import 'package:atti/patient/screen/memory/memory_register/MemoryRegisterFinish.dart';

class MemoryRegisterCheck extends StatefulWidget {
  const MemoryRegisterCheck({super.key});

  @override
  State<MemoryRegisterCheck> createState() => _MemoryRegisterCheckState();
}

class _MemoryRegisterCheckState extends State<MemoryRegisterCheck> {
  final MemoryNoteController memoryNoteController = Get.put(
      MemoryNoteController());
  bool isLoading = false; // 로딩 상태 변수 추가
  final ColorPallet colorPallet = Get.put(ColorPallet());

  Future<XFile?> convertImageToWebp(File file) async {
    // 원본 파일 경로에서 확장자 부분을 제거하고 .webp를 붙임
    final targetPath = file.path.substring(0, file.path.lastIndexOf('.')) +
        '.webp';

    // flutter_image_compress를 사용해 이미지 변환 수행
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70, // 압축 품질 (0~100)
      format: CompressFormat.webp, // 변환할 포맷을 WebP로 지정
    );

    return result != null ? XFile(result.path) : null;
  }

  // 등록 버튼 클릭 시 실행되는 함수
  Future<void> onRegisterPressed(BuildContext context) async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    try {
      String tmpImg = memoryNoteController.memoryNote.value.img ?? '';

      // 이미지 WebP 변환 (기존 이미지가 있는 경우)
      if (tmpImg.isNotEmpty) {
        File originalFile = File(tmpImg);
        XFile? webpFile = await convertImageToWebp(originalFile);

        if (webpFile != null) {
          tmpImg = webpFile.path; // 변환된 이미지 경로 저장
          memoryNoteController.memoryNote.update((val) {
            val!.img = tmpImg; // 변환된 이미지 경로 업데이트
          });
        }
      }

      // 메모리 등록 로직 실행
      memoryNoteController.tmpImgTitle.value =
      memoryNoteController.memoryNote.value.imgTitle!;
      memoryNoteController.addMemoryNote();

      // 등록 완료 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MemoryRegisterFinish()),
      );
    } catch (e) {
      print('Error during registration: $e');
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> keywords = memoryNoteController.memoryNote.value
        .keyword ?? [];
    final List<String> people = memoryNoteController.memoryNote.value
        .selectedFamilyMember ?? [];
    ColorPallet colorPallet = ColorPallet();

    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;


    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DetailPageTitle(
                title: '기억 남기기',
                totalStep: 0,
                currentStep: 0),

            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: width * 0.04,),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: const Text('다음과 같이 등록할까요?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.025,),

                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${memoryNoteController.memoryNote.value.era
                          .toString()}년대',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '\'${memoryNoteController.memoryNote.value.imgTitle
                          .toString()}\'',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 30,
                          height: 1.0
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  // 이미지
                  Container(
                    margin: EdgeInsets.only(left: width * 0.05),
                    //alignment: Alignment.centerLeft,
                    constraints: BoxConstraints(maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height * 0.3),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: memoryNoteController.memoryNote.value.img != null
                        ? Image.file(
                      File(memoryNoteController.memoryNote.value.img!),
                      fit: BoxFit.cover, // 이미지의 크기를 조정
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                    )
                        : const SizedBox(), // 널일 경우 대체할 위젯 설정
                  ),
                  SizedBox(height: width * 0.05,),

                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: const Text('함께한 사람',
                      textAlign: TextAlign.left, style: TextStyle(
                        fontSize: 24,
                      ),),
                  ),
                  SizedBox(height: width * 0.01,),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 15),
                      child: MemoryPeople(keywords: people)),

                  SizedBox(height: width * 0.05,),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
                    alignment: Alignment.centerLeft,
                    child: const Text('기억 단어',
                      textAlign: TextAlign.left, style: TextStyle(
                        fontSize: 24,
                      ),),
                  ),
                  SizedBox(height: width * 0.01,),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 15),
                      child: MemoryKeyword(keywords: keywords)),
                  const SizedBox(height: 30,),


                ],
              ),
            )),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextButton(
                    onPressed: isLoading ? null : () =>
                        onRegisterPressed(context), // 로딩 중이면 비활성화,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          colorPallet.orange),
                      minimumSize: WidgetStateProperty.all(
                          Size(width * 0.425, 50)),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colorPallet.goldYellow)
                        ) // 로딩 중이면 인디케이터 표시
                        : Text('등록',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextButton(
                    onPressed: () {
                      memoryNoteController.tmpImgTitle.value =
                      memoryNoteController.memoryNote.value.imgTitle!;
                      memoryNoteController.addMemoryNote();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MemoryRegister1()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      )),
                      minimumSize: WidgetStateProperty.all(
                          Size(MediaQuery
                              .of(context)
                              .size
                              .width * 0.425, 50)),
                    ),
                    child: const Text('수정',
                      style: TextStyle(color: Colors.black, fontSize: 20),),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}

class MemoryPeople extends StatelessWidget {
  final keywords;

  const MemoryPeople({super.key, this.keywords});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 10,
      // 가로 간격 설정
      runSpacing: 10,
      // 세로 간격 설정
      children: List.generate(keywords.length ?? 0, (index) {
        return TextButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            // 클릭 시 효과나 모션 없애기
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(
                color: Colors.black,
                width: 0.7,
              ),
            )),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(13, 5, 13, 7),
            child: Text(
              keywords[index],
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              ),),
          ),
        );
      }).toList(),
    );
  }
}


class MemoryKeyword extends StatelessWidget {
  const MemoryKeyword({super.key, this.keywords});

  final keywords;

  @override
  Widget build(BuildContext context) {
    ColorPallet colorPallet = ColorPallet();
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 10,
      // 가로 간격 설정
      runSpacing: 10,
      // 세로 간격 설정
      children: List.generate(keywords.length ?? 0, (index) {
        return TextButton(
          onPressed: () {},
          style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            backgroundColor: WidgetStateProperty.all(colorPallet.lightYellow),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            // 클릭 시 효과나 모션 없애기
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
          ),
          child: Container(
            padding: const EdgeInsets.only(
                left: 20, right: 20, bottom: 8, top: 5),
            child: Text(
              keywords[index],
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
