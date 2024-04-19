import 'package:animate_do/animate_do.dart';
import 'package:clothsonrent/src/ui/authentication/signin_screen.dart';
import 'package:clothsonrent/src/ui/authentication/verify_code.dart';
import 'package:clothsonrent/src/utils/uitilities.dart';
import 'package:clothsonrent/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phonecontroller = TextEditingController();
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final String phoneNumberPrefix = "+91 ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Image.asset('assets/images/image1.jpg', fit: BoxFit.cover, width: 200),
              ),
              SizedBox(height: 30.h),
              FadeInDown(child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey.shade900))),
              SizedBox(height: 10.h),
              FadeInDown(
                delay: Duration(milliseconds: 200),
                child: Text(
                    '"Welcome to our Fashion Rental App! Rent stylish clothes with ease!!"',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),

              ),
              SizedBox(height: 20.h),
              FadeInDown(
                delay: Duration(milliseconds: 400),
                child: Stack(
                  children: [
                    CustomTextFormField(
                      controller: _phonecontroller,
                      prefixText: phoneNumberPrefix,
                      labelText: "Mobile Number",
                      hintText: "12345 67890",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Number';
                        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              FadeInDown(
                delay: Duration(milliseconds: 600),
                child: CustomElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberPrefix + _phonecontroller.text,
                      verificationCompleted: (_) {
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      verificationFailed: (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCodeScreen(
                              verificationId: verificationId,
                              phoneNumber: _phonecontroller.text,
                            ),
                          ),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        Utils().toastMessage(verificationId);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    );
                  },
                  label: 'Request OTP',
                ),  
              ),
            ],
          ),
        ),
      ),
    );
  }
}
