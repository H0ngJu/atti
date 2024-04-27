import 'package:atti/commons/colorPallet.dart';
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final ColorPallet _colorPallet = ColorPallet(); // ColorPallet 클래스 인스턴스가 필요함

  ErrorMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        message,
        style: TextStyle(
          color: _colorPallet.alertColor,
        ),
      ),
    );
  }
}