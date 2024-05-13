import 'package:clothsonrent/src/ui/authentication/login_screen.dart';
import 'package:clothsonrent/src/ui/splashscreen.dart';
import 'package:clothsonrent/src/view/mycart.dart';
import 'package:clothsonrent/src/view/homescreen.dart';
import 'package:clothsonrent/src/view/notificationscreen.dart';
import 'package:clothsonrent/src/view/profile.dart';
import 'package:clothsonrent/src/view/putonrent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: Size(360, 690),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/put_on_rent': (context) => PutOnRent(),
          '/profile': (context) => ProfileScreen(),
          '/my_cart':(context) => MyCartScreen(),
          '/notification':(context) => NotificationScreen(),
        },
      ),
    );
  }
}
