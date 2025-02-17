// 화면 하단의 다음 버튼
// 사용법 :
// NextButton(next: ScheduleRegister2(), content: '다음', isEnabled: isButtonEnabled())
// next: 버튼을 눌렀을 때 이동할 위젯, content: 버튼에 들어갈 텍스트, isEnabled: 버튼 활성화 여부 (필요없으면 true 넣으면 됨)
import 'package:atti/index.dart';


final ColorPallet colorPallet = Get.put(ColorPallet());

class BottomNextButton extends StatelessWidget {
  const BottomNextButton(
      {super.key, this.next, this.content, required this.isEnabled});

  final next;
  final content;
  final bool isEnabled; // 버튼 활성화 여부

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20),
      child: TextButton(
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => next),
                );
              }
            : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
              isEnabled ? colorPallet.goldYellow : Colors.white), // 비활성화일 때 색상을 조절
          minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width * 0.9, 50)),
          side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {

            if (!isEnabled) { // isEnabled가 false일 때만 검은색 테두리를 추가
              return const BorderSide(color: Colors.black, width: 1);
            }
            return BorderSide.none; // 테두리 없음
          }),
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 20,
          color: Colors.black),
        ),
      ),
    );
  }
}
