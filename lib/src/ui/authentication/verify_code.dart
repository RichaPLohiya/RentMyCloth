import 'dart:async';
import 'package:clothsonrent/src/utils/uitilities.dart';
import 'package:clothsonrent/src/view/profile.dart';
import 'package:clothsonrent/src/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyCodeScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final _verificationCodeController = TextEditingController();
  late Timer _timer;
  int _timerSeconds = 60;
  bool _timerActive = true;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_timerSeconds == 0) {
          setState(() {
            _timerActive = false;
          });
          timer.cancel();
        } else {
          setState(() {
            _timerSeconds--;
          });
        }
      },
    );
  }

  void _resendOTP() {
    setState(() {
      _timerSeconds = 60;
      _startTimer();
      _otpSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          const Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
            child: Text(
              'OTP Verification',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12.h),
          const Text(
            'Enter the 6 digit OTP to continue the session on ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(widget.phoneNumber,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(height:12.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: PinCodeTextField(
              keyboardType: TextInputType.number,
              appContext: context,
              length: 6,
              onChanged: (value) {},
              onCompleted: (value) {
                _verifyCode(value);
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 45.h,
                fieldWidth: 40.w,
                activeFillColor: Colors.deepPurple,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: Colors.deepPurpleAccent,
                selectedColor: Colors.deepPurpleAccent,
                inactiveColor: Colors.black,
                borderWidth: 2,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:200),
            child: Text(
              '$_timerSeconds seconds left',
              style: TextStyle(fontSize: 18, color: Colors.black ),
            ),
          ),
          SizedBox(height: 10.h),
          CustomElevatedButton(

            label: "Verify",
            loading: _isLoading,
            onPressed: _timerActive
                ? null
                : () async {
              _verifyCode(_verificationCodeController.text);
            },
          ),
          SizedBox(height: 25.h),
          Text("Didn't Received The OTP?",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: _timerActive ? null : () {
              _resendOTP();
            },
            child: Text('Resend OTP ',
              style: TextStyle(color: _timerActive ? Colors.grey : Colors.red, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyCode(String code) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Utils().toastMessage(e.toString());
    }
  }
}
