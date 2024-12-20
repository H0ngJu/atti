import 'package:flutter/material.dart';

AppBar MemoryRegisterAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      '기억 남기기',
      style: TextStyle(
        fontSize: 24,
      ),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}
