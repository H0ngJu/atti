import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpController extends GetxController {
  RxBool isPatient = true.obs;
  var userEmail = "".obs;
  var userPassword = "".obs;
  var userName = "".obs;
  DateTime? userBirthDate;
  RxList<String> userFamily = [""].obs;
}