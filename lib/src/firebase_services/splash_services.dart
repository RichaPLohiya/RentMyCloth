import 'dart:async';
import 'package:clothsonrent/src/ui/authentication/login_screen.dart';
import 'package:clothsonrent/src/view/homescreen.dart';
import 'package:clothsonrent/src/view/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;

    if(_user != null){
      Timer(const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ),
      );
    }else{
      Timer(const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
      );
    }
  }
}