import 'package:flutter/material.dart';
import 'package:atti/commons/colorPallet.dart';

class CustomerTypeBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final int isPressed;
  final int buttonId;
  final String mainText;
  final String detailText;

  const CustomerTypeBtn({
    super.key,
    required this.onPressed,
    required this.isPressed,
    required this.buttonId,
    required this.mainText,
    required this.detailText,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();

    return TextButton(
      onPressed: onPressed, // 생성자를 통해 받은 onPressed 함수를 사용
      style: TextButton.styleFrom(
        backgroundColor: isPressed == buttonId ? _colorPallet.lightYellow : null, // isPressed 값에 따라 배경색 결정
        padding: EdgeInsets.zero,
        side: BorderSide(
            width: 1,
            color: isPressed == buttonId ? _colorPallet.textColor : Colors.black // isPressed 값에 따라 테두리 색상 결정
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        elevation: 0,
      ),
      child: Container(
        width: width * 0.4,
        height: height * 0.3,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mainText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PretendardBold',
                ),
              ),
              SizedBox(height: height * 0.01,),
              Text(
                detailText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'PretendardRegular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}