import 'package:atti/data/notification/notification_controller.dart';
import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final String title; // 제목 텍스트
  final VoidCallback onYesPressed; // '네' 버튼 클릭 시 실행할 함수
  final VoidCallback onNoPressed; // '아니요' 버튼 클릭 시 실행할 함수
  final Color yesButtonColor; // '네' 버튼의 배경 색상

  const CustomModal({
    super.key,
    required this.title,
    required this.onYesPressed,
    required this.onNoPressed,
    this.yesButtonColor = const Color(0xFFFFC107), // 기본값: 노란색
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 닫기 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xffB8B8B8),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),

            // 제목 텍스트
            SizedBox(
              height: height * 0.02,
              width: width * 0.8,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                height: 1.2
              ),
            ),

            SizedBox(height: authController.isPatient
                ? height * 0.3
                : height * 0.25),

            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // '네' 버튼
                SizedBox(
                  width: width * 0.37,
                  child: TextButton(
                    onPressed: onYesPressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(yesButtonColor),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      '네',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),

                // '아니요' 버튼
                SizedBox(
                  width: width * 0.37,
                  child: TextButton(
                    onPressed: onNoPressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                      side: WidgetStateProperty.all(
                        const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text(
                      '아니요',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
