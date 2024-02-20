import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../auth_controller.dart';

class ChatController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final _db = FirebaseFirestore.instance;
  var tmpChatName = ''.obs;

  Future<void> updateChat(String chat, String path) async {
    try {
      var documentSnapshot = await _db.doc(path).get();
      String currentChat = documentSnapshot['chat'] ?? "";
      if (currentChat.length > 0) {
        chat = currentChat + "," + chat.substring(1, chat.length - 1);
      }
      else {
        chat = chat.substring(1, chat.length - 1);
      }
      await _db.doc(path).update({'chat': chat});
    } catch (e) {
      print('Error adding chat : $e');
    }
  }

  static Future<String> getChat(String path) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance.doc(path).get();
      return documentSnapshot['chat'];
    } catch (e) {
      print('Error getting chat : $e');
      return "";
    }
  }
}
