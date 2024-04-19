import 'package:clothsonrent/src/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashscreen = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashscreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Container(
          height:double.infinity,
          width: double.infinity,
          child: Center(
            child: Image.asset('assets/images/logo1.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
