import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpController extends GetxController {
  RxBool isPatient = true.obs;
  var userEmail = "".obs;
  var userPatientEmail = "".obs;
  var userPassword = "".obs;
  var userName = "".obs;
  DateTime? userBirthDate;
  var userPhoneNumber = "".obs;
  late RxList<String> userFamily = <String>[].obs;

  int calculateAge() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - userBirthDate!.year;

    if (currentDate.month < userBirthDate!.month ||
        (currentDate.month == userBirthDate!.month && currentDate.day < userBirthDate!.day)) {
      age--;
    }
    return age;
  }
}