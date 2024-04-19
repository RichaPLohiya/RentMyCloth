import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.deepPurple,
              size: 30.0,
            ),
          ),
          automaticallyImplyLeading: true,
          title: const Text(
            "Terms & Conditions",
            style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Introduction",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "These terms and conditions govern your use of the peer-to-peer platform application . By accessing or using the App, you agree to be bound by these terms and conditions.",
               style: TextStyle(fontSize: 16.0),),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Registration",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "To register on the platform, users must provide accurate and complete information. Users are responsible for maintaining the confidentiality of their account credentials.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                   Text(
                    " Rental and Purchase",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                   ),
                 ],
               ),
              SizedBox(height: 8.0.h),
              const Text(
                    "Users can list their outfits for rent or purchase on the platform. Renters and buyers must comply with the terms specified by the outfit owner.",
                    style: TextStyle(fontSize: 16.0),
                  ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Payment and Fees",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "Payments for rentals and purchases are processed securely through the platform. Users may be subject to service fees or transaction fees.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Liability",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "The App is not liable for any damages or losses resulting from transactions between users. Users are advised to exercise caution and use the platform responsibly.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Modification of Terms",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "The App reserves the right to modify these terms and conditions at any time. Users will be notified of any changes, and continued use of the App constitutes acceptance of the modified terms.",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

