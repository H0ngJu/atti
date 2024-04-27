import 'package:atti/commons/ErrorMessageWidget.dart';
import 'package:atti/commons/colorPallet.dart';
import 'package:atti/data/signup_login/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginEntryField extends StatefulWidget {
  final String fieldName;
  final int fieldId;
  final String errorMessage;
  final String hintText;
  final bool isValid;
  final TextInputType inputType;
  final Function(String) onChanged;
  final bool isPassword;

  LoginEntryField({
    super.key,
    required this.fieldName,
    required this.fieldId,
    required this.errorMessage,
    required this.hintText,
    required this.isValid,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    required this.onChanged,
  });

  @override
  State<LoginEntryField> createState() => _LoginEntryFieldState();
}

class _LoginEntryFieldState extends State<LoginEntryField> {
  bool isFocused = false; // 추가된 상태

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ColorPallet _colorPallet = ColorPallet();
    LoginController _loginController = Get.find<LoginController>();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldName,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height*0.01),
            padding: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 7.0, left: 9.0),
            decoration: BoxDecoration(
              color: _colorPallet.lightYellow,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: _loginController.isPressed.value == widget.fieldId ? _colorPallet.textColor : _colorPallet.lightYellow,
              ),
            ),
            child: TextFormField(
              onTap: () {
                setState(() {
                  _loginController.isPressed.value = widget.fieldId;
                });
                print("isPressed = ${_loginController.isPressed.value}\nfieldId = ${widget.fieldId}");
              },
              obscureText: widget.isPassword,
              onChanged: widget.onChanged,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 24,
                  color: _colorPallet.textColor,
                ),
              ),
              style: TextStyle(
                  fontSize: 24
              ),
            ),
          ),
          if ( _loginController.isPressed.value == widget.fieldId && !widget.isValid)
            ErrorMessageWidget(message: widget.errorMessage)
        ],
      ),
    );
  }
}
