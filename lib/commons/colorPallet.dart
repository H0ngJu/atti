import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ColorPallet extends GetxController {
  Color yellow = Color(0xffFFE9B3);

  Color orange = Color(0xffFF6200); // select1
  Color goldYellow = Color(0xffFFC215); // select 2
  Color lightGray = Color(0xffEDEDED); // select 3
  Color lightYellow = Color(0xffFFEFC6); // blank
  Color black = Color(0xff262626); // option
  Color gray = Color(0xff868686); // detail text
  Color khaki = Color(0xff745C20); // blank text

  Color textColor = Color(0xffA38130);
  Color alertColor = Color(0xffB62E26);
}