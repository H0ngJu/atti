import 'package:flutter/material.dart';

class YesNoActionButtons extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const YesNoActionButtons({
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
      margin: EdgeInsets.only(bottom: 20),
      width: width * 0.9,
      child: Row(
        children: [
          TextButton(
            onPressed: onPrimaryPressed,
            child: Text(
              primaryText,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xffFFC215)),
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.43, 50)),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
          TextButton(
            onPressed: onSecondaryPressed,
            child: Text(
              secondaryText,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.43, 50)),
              side: MaterialStateProperty.all(BorderSide(
                color: Colors.black,
                width: 1,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
