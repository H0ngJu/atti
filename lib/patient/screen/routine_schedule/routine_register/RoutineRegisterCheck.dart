import 'dart:io';

import 'package:atti/commons/YesNoActionButtonsAsync.dart';
import 'package:atti/data/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:atti/commons/DetailPageTitle.dart';
import 'package:atti/data/routine/routine_controller.dart';
import '../../../../commons/RoutineBox.dart';
import '../../../../commons/colorPallet.dart';
import '../../../../data/notification/notification_controller.dart';
import 'RoutineRegister1.dart';
import 'RoutineRegisterFinish.dart';

class RoutineRegisterCheck extends StatefulWidget {
  const RoutineRegisterCheck({super.key});

  @override
  State<RoutineRegisterCheck> createState() => _RoutineRegisterCheckState();
}

class _RoutineRegisterCheckState extends State<RoutineRegisterCheck> {
  final RoutineController routineController = Get.put(RoutineController());
  NotificationService notificationService = NotificationService();
  final ColorPallet colorPallet = Get.put(ColorPallet());

  bool isLoading = false; // 로딩 상태 변수

  // ['월', '수', '금'] -> [1, 3, 5]
  List<int> mapDaysToNumbers(List<String> repeatDays) {
    final dayMapping = {
      '월': 1,
      '화': 2,
      '수': 3,
      '목': 4,
      '금': 5,
      '토': 6,
      '일': 7,
    };
    return repeatDays.map((day) => dayMapping[day]!).toList();
  }

  Future<XFile?> convertImageToWebp(File file) async {
    // 원본 파일 경로에서 확장자 부분을 제거하고 .webp를 붙임
    final targetPath = file.path.substring(0, file.path.lastIndexOf('.')) + '.webp';

    // flutter_image_compress를 사용해 이미지 변환 수행
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70, // 압축 품질 (0~100)
      format: CompressFormat.webp, // 변환할 포맷을 WebP로 지정
    );

    return result != null ? XFile(result.path) : null;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const DetailPageTitle(
                        title: '일과 등록하기',
                        description: '다음과 같이 등록할까요?',
                        totalStep: 0,
                        currentStep: 0,
                      ),
                      const SizedBox(height: 30),
                      RoutineBox(
                        time: routineController.routine.value.time ?? '',
                        name: routineController.routine.value.name ?? '',
                        img: routineController.routine.value.img ?? '',
                        days: (routineController.routine.value.repeatDays ?? [])
                            .map<String>((day) => day.toString())
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              YesNoActionButtonsAsync(
                primaryText: '등록',
                secondaryText: '수정',
                onPrimaryPressed: isLoading
                    ? null // 로딩 중이면 클릭 불가
                    : () async {
                  setState(() {
                    isLoading = true; // 로딩 상태 시작
                  });

                  try {
                    routineController.routine.value.isMedicine = false;
                    String tmpName = routineController.routine.value.name!;
                    String tmpImg = routineController.routine.value.img!;
                    List<int> tmpTime = routineController.routine.value.time!;
                    List<int> repeatDaysToNumList = mapDaysToNumbers(
                        routineController.routine.value.repeatDays!);

                    // 이미지 WebP 변환 시작
                    File originalFile = File(tmpImg); // 기존 이미지 파일
                    XFile? webpFile = await convertImageToWebp(originalFile);

                    if (webpFile != null) {
                      tmpImg = webpFile.path; // 변환된 이미지 경로 저장
                      routineController.routine.update((val) {
                        val!.img = tmpImg; // 변환된 이미지 경로 업데이트
                      });
                    }

                    final updatedRoutine = await routineController.addRoutine();

                    // 환자라면 알림 설정
                    if (authController.isPatient) {
                      await notificationService.showWeeklyNotification(
                        tmpName,
                        repeatDaysToNumList,
                        tmpTime[0],
                        tmpTime[1],
                        updatedRoutine.reference!.id,
                      );
                    }


                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoutineRegisterFinish(
                          name: tmpName,
                          time: tmpTime,
                          img: tmpImg,
                        ),
                      ),
                    );
                  } catch (e) {
                    // 에러 처리
                    print('Error: $e');
                  } finally {
                    setState(() {
                      isLoading = false; // 로딩 상태 종료
                    });
                  }
                },
                onSecondaryPressed: () {
                  Get.to(const RoutineRegister1());
                },
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorPallet.goldYellow),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
