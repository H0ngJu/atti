import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class NextBtn extends StatefulWidget {
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
  State<NextBtn> createState() => _NextBtnState();
}

class _NextBtnState extends State<NextBtn> {
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
          onPressed: widget.isButtonDisabled ? null : () async {
            if (widget.onButtonClick != null) {
              await widget.onButtonClick!();
            }
            if (widget.nextPage != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget.nextPage!)
              );
            }
          },
          style: TextButton.styleFrom(
              backgroundColor: widget.isButtonDisabled ? Colors.white : _colorPallet.goldYellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: widget.isButtonDisabled ? Colors.black : _colorPallet.goldYellow,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30)
              )
          ),
          child: Text(widget.buttonName == null ? '다음' : widget.buttonName!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: widget.isButtonDisabled
                  ? Colors.black
                  : Colors.white,
              fontFamily: 'PretendardBold',
            ),
          ),
        )
    );
  }
}
