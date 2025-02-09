import 'package:flutter/material.dart';

class YesNoActionButtonsAsync extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  final Future<void> Function()? onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const YesNoActionButtonsAsync({
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: width * 0.9,
      child: Row(
        children: [
          TextButton(
            onPressed: onPrimaryPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xffFF6200)),
              minimumSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.43, 50)),
            ),
            child: Text(
              primaryText,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          TextButton(
            onPressed: onSecondaryPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              minimumSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.43, 50)),
              side: WidgetStateProperty.all(const BorderSide(
                color: Colors.black,
                width: 1,
              )),
            ),
            child: Text(
              secondaryText,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
