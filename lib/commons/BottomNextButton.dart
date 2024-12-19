// 화면 하단의 다음 버튼
// 사용법 :
// NextButton(next: ScheduleRegister2(), content: '다음', isEnabled: isButtonEnabled())
// next: 버튼을 눌렀을 때 이동할 위젯, content: 버튼에 들어갈 텍스트, isEnabled: 버튼 활성화 여부 (필요없으면 true 넣으면 됨)
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton(
      {super.key, this.next, this.content, required this.isEnabled});

  final next;
  final content;
  final bool isEnabled; // 버튼 활성화 여부

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: 20),
      child: TextButton(
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => next),
                );
              }
            : null,
        child: Text(
          content,
          style: TextStyle(fontSize: 20,
          color: Colors.black),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              isEnabled ? Color(0xffFFC215) : Colors.white), // 비활성화일 때 색상을 조절
          minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.9, 50)),
          side: MaterialStateProperty.resolveWith<BorderSide>((Set<MaterialState> states) {

            if (!isEnabled) { // isEnabled가 false일 때만 검은색 테두리를 추가
              return BorderSide(color: Colors.black, width: 1);
            }
            return BorderSide.none; // 테두리 없음
          }),
        ),
      ),
    );
  }
}
