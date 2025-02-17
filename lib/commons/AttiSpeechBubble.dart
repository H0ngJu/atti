import 'package:flutter/material.dart';
import 'package:atti/index.dart';

Widget AttiSpeechBubble({
  required String comment,
  required Color color,
}) =>
    ClipPath(
      clipper: MyClipper(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 20,
          bottom: 15,
        ),
        color: color,
        child: Text(
          comment,
          textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'UhBee',
                fontSize: 24,
                height: 1.7
            )
        ),
      ),
    );

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start at the top-left corner
    path.moveTo(15, 15);

    // Draw the top edge
    path.lineTo(size.width - 48, 15);

    // Draw the tail
    path.lineTo(size.width - 45, 10); // Move upwards for the tail
    path.quadraticBezierTo(size.width - 40, -10, size.width - 40, 0); // Rounded corner
    path.lineTo(size.width - 30, 15); // Return to the box

    // Draw the rest of the top edge
    path.lineTo(size.width - 15, 15);

    // Top-right corner curve
    path.quadraticBezierTo(size.width, 15, size.width, 30);

    // Right edge
    path.lineTo(size.width, size.height - 15);

    // Bottom-right corner curve
    path.quadraticBezierTo(size.width, size.height, size.width - 15, size.height);

    // Bottom edge
    path.lineTo(15, size.height);

    // Bottom-left corner curve
    path.quadraticBezierTo(0, size.height, 0, size.height - 15);

    // Left edge
    path.lineTo(0, 30);

    // Top-left corner curve
    path.quadraticBezierTo(0, 15, 15, 15);

    return path;
  }


  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

