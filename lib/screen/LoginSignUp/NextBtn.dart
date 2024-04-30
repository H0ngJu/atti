import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class NextBtn extends StatelessWidget {
  final bool isButtonDisabled;
  final Widget? nextPage;
  final Function? onButtonClick;
  final String? buttonName;

  const NextBtn({
    super.key,
    required this.isButtonDisabled,
    this.nextPage,
    this.onButtonClick,
    this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();

    return Container(
        margin: EdgeInsets.only(top: height*0.3),
        width: width*0.9,
        height: height*0.07,
        child: TextButton(
          onPressed: isButtonDisabled ? null : () async {
            if (onButtonClick != null) {
              await onButtonClick!();
            }
            if (nextPage != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage!)
              );
            }
          },
          style: TextButton.styleFrom(
              backgroundColor: isButtonDisabled ? Colors.white : _colorPallet.goldYellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isButtonDisabled ? Colors.black : _colorPallet.goldYellow,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30)
              )
          ),
          child: Text(buttonName == null ? '다음' : buttonName!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: isButtonDisabled
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        )
    );
  }
}
