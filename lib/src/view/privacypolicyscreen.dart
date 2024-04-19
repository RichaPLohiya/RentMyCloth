import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
            "Privacy Policy",
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
                    " Information Collection",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "We collect personal information from users when they register on our platform or engage in transactions. This information may include name, address, contact information, and payment details.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Use of Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "Personal information collected is used to provide and improve our services, process transactions, and communicate with users. We may also use this information for marketing purposes with user consent.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Data Security",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "We implement security measures to protect user data against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Third-Party Services",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "We may use third-party services to facilitate our services and analyze user behavior. These third parties have their own privacy policies governing the use of user information.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0.h),
              const Row(
                children: [
                  Icon(Icons.circle,size: 15,),
                  Text(
                    " Changes to Privacy Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0.h),
              const Text(
                "We reserve the right to update our privacy policy at any time. Users will be notified of any changes, and continued use of our platform constitutes acceptance of the modified policy.",
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}