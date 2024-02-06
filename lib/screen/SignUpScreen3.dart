import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({super.key});

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null){
        loggedUser = user;
        print(loggedUser!.email);
      };
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
